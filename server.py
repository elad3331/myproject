import asyncio
import base64
import hashlib
import os
import sqlite3
import threading
import time

import requests
import websockets

online_users = set()
ids = set()
founds = set()
loses = set()
key = "elad"


class User:
    def __init__(self, username, password, email, websocket):
        self.username = username
        self.password = password
        self.email = email
        self.websocket = websocket
        self.logged_in = True


"""*
async def send_to_other(dest_user, message):
    print("inbroad")
    for user in online_users:
        print("online " + user.username)
        if user.websocket is None:
            print("NONE")
        print(dest_user + "dest")
        if dest_user == user.username and user.websocket is not None:
            print("here")
            await user.websocket.send(message)
*"""

"""
def timer_thread():
    global elad12web
    global elad123web
    while True:

        print("timer " + str(len(online_users)))
        if elad12web is None:
            print("timer elad12 None")
        else:
            print("timer elad12 Not None." + str(type(elad12web)))

        if elad123web is None:
            print("timer elad123 None")
        else:
            print("timer elad123 Not None." + str(type(elad123web)))


        for user in online_users:
            print("timer online users is, " + user.username)
            if user.websocket is None:
                print("timer None")
            else:
                print("timer Not None")
        time.sleep(5)
"""


async def handle_message(websocket, path):
    print("here")
    registered_users = read_from_db(connection)
    read_ids(connection1, connection2)
    get_products(connection1, connection2)
    try:
        print("try")
        async for message in websocket:
            print("got message" + message)
            parts = message.split(" ")
            message_type = parts[0]

            if message_type == "Login":
                username = parts[1]
                password = parts[2]

                for registered in registered_users:
                    md5_password = md5_encrypt(password)
                    if registered[0] == username and registered[1] == md5_password:
                        if websocket is None:
                            print("is none " + username)

                        user = User(username, md5_password, registered[2], websocket)

                        online_users.add(user)
                        await websocket.send("Login,Succeed,Server," + username)
                        break
                else:
                    await websocket.send("Login,Failed,Server,")


            elif message_type == "Registration":
                username = parts[1]
                password = parts[2]
                md5_password = md5_encrypt(password)
                email = parts[3]
                for registered in registered_users:
                    if registered[0] == username:
                        await websocket.send("Registration,Failed,Server,user already exists")
                        break
                else:
                    user = User(username, md5_password, email, websocket)
                    online_users.add(user)
                    cursor.execute("INSERT INTO users_db (username,password,email,users_list) VALUES (?,?,?,?)",
                                   (username, md5_password, email, ""))
                    connection.commit()
                    registered_users.append((username, md5_password, email))
                    await websocket.send("Registration,Succeed,Server," + username)


            elif message_type == "Chat":
                match_users = set()
                src_name = parts[1]
                dst_name = parts[2]
                chat_msg = " ".join(parts[3:])
                print("length " + str(len(online_users)))
                for match in online_users:
                    if dst_name == match.username:
                        print("dst is " + dst_name)
                        if match.websocket is not None:
                            match_users.add(match.websocket)
                        else:
                            print(f"Warning: websocket for {match.username} is None")
                print(f"Sending message to {len(match_users)} users")
                for ws in match_users:
                    try:
                        result = await ws.send("Chat,Succeed,Server," + src_name + " " + chat_msg)
                        print(f"Message sent to {ws}: {result}")
                    except Exception as e:
                        print(f"Error sending message to {ws}: {e}")

            elif message_type == "Get_Chats":
                print("in chats")
                select_command = "SELECT users_list FROM users_db WHERE username = ?"
                cursor.execute(select_command, (username,))
                current_users_list = cursor.fetchone()[0]
                msg = "GetChats,Succeed,Server,"
                await websocket.send(msg + " " + current_users_list)

            elif message_type == "Get_Cities":
                print("in cities")
                cities = get_english_names("https://raw.githubusercontent.com/royts/israel-cities/master/israel-cities.json")
                msg = "Cities,Succeed,Server," + cities
                await websocket.send(msg)


            elif message_type == "Lost":
                get_products(connection1, connection2)
                username = parts[1]
                product_type = parts[2]
                product_color = parts[3]
                product_condition = parts[4]
                product_id = generate_new_id()
                cursor1.execute("INSERT INTO losses_db (id,username,type,color,condition) VALUES (?,?,?,?,?)",
                                (product_id, username, product_type, product_color, product_condition))
                connection1.commit()
                message_sent = False
                match_users = set()
                for found in founds:
                    if find_match((product_id, username, product_type, product_color, product_condition), found):
                        update_users_list(username, found[1])
                        update_users_list(found[1], username)
                        message_sent = True
                        for match in online_users:
                            if found[1] == match.username:
                                match_users.add(match.websocket)
                if len(match_users) > 1:
                    await websocket.send("Match,Succeed,Server,Found Several Users")
                    await asyncio.gather(*[ws.send("Match,Succeed,Server,Lost " + username) for ws in match_users])
                elif len(match_users) == 1:
                    await websocket.send("Match,Succeed,Server,Found " + found[1])
                    await asyncio.gather(*[ws.send("Match,Succeed,Server,Lost " + username) for ws in match_users])
                if not message_sent:
                    await websocket.send("Match,Failed,Server, ")

            elif message_type == "Found":
                get_products(connection1, connection2)
                username = parts[1]
                product_type = parts[2]
                product_color = parts[3]
                product_condition = parts[4]
                product_id = generate_new_id()
                cursor2.execute("INSERT INTO findings_db (id,username,type,color,condition) VALUES (?,?,?,?,?)",
                                (product_id, username, product_type, product_color, product_condition))
                connection2.commit()
                message_sent = False
                match_users = set()
                for lose in loses:
                    if find_match((product_id, username, product_type, product_color, product_condition), lose):
                        update_users_list(username, lose[1])
                        update_users_list(lose[1], username)
                        message_sent = True
                        for match in online_users:
                            if lose[1] == match.username:
                                match_users.add(match.websocket)
                if len(match_users) > 1:
                    await websocket.send("Match,Succeed,Server,Lost Several Users")
                    await asyncio.gather(*[ws.send("Match,Succeed,Server,Found " + username) for ws in match_users])
                elif len(match_users) == 1:
                    await websocket.send("Match,Succeed,Server,Lost " + lose[1])
                    await asyncio.gather(*[ws.send("Match,Succeed,Server,Found " + username) for ws in match_users])
                if not message_sent:
                    await websocket.send("Match,Failed,Server, ")

    except websockets.exceptions.ConnectionClosedError:
        for user in online_users:
            if user.websocket == websocket:
                print(user.username + " here")
                user.logged_in = False
                user.websocket = None
                break


async def main():
    # timer = threading.Thread(target=timer_thread)
    # timer.daemon = True
    # timer.start()
    async with websockets.serve(handle_message, "192.168.56.1", 12345):
        await asyncio.Future()  # run forever


def xor_encrypt_decrypt(encrypted_text):
    decrypted = []
    for i in range(len(encrypted_text)):
        char_code = ord(encrypted_text[i]) ^ ord(key[i % len(key)])
        decrypted.append(char_code)
    return ''.join(chr(char) for char in decrypted)


def get_english_names(url):
    response = requests.get(url)
    data = response.json()  # assuming the file contains JSON data

    english_names = ""
    counter = 0
    for block in data:
        if counter != 0:
            english_name = block.get('english_name')
            if english_name:
                english_names += english_name + ","
        counter += 1
    return english_names


def md5_encrypt(message):
    md5_hash = hashlib.md5()
    md5_hash.update(message.encode('utf-8'))
    encrypted = md5_hash.hexdigest()
    return encrypted


def update_users_list(username, new_username):
    select_command = "SELECT users_list FROM users_db WHERE username = ?"
    cursor.execute(select_command, (username,))
    current_users_list = cursor.fetchone()[0]
    print("user " + username)
    print("new " + new_username)
    if current_users_list is not None:
        print("noe none")
        if current_users_list != "":
            print("not equal")
            if new_username not in current_users_list:
                updated_users_list = current_users_list + " " + new_username
                update_command = "UPDATE users_db SET users_list = ? WHERE username = ?"
                cursor.execute(update_command, (updated_users_list, username))
                connection.commit()
        else:
            print("else")
            updated_users_list = new_username
            update_command = "UPDATE users_db SET users_list = ? WHERE username = ?"
            cursor.execute(update_command, (updated_users_list, username))
            connection.commit()


def generate_new_id():
    while True:
        random_bytes = os.urandom(6)  # the id is 4 bytes of base64
        user_id = base64.b64encode(random_bytes).decode('utf-8')
        if user_id not in ids:  # check for collision
            ids.add(user_id)
            return user_id


def read_ids(conn, conn1):
    cursor = conn.execute("SELECT * from losses_db")
    for row in cursor:
        ids.add(row[0])
    cursor1 = conn1.execute("SELECT * from findings_db")
    for row in cursor1:
        ids.add(row[0])


def read_from_db(conn):
    cursor = conn.execute("SELECT * from users_db")
    registered_users = []
    for row in cursor:
        registered_users.append((row[0], row[1], row[2]))
    return registered_users


# gets two products and returns it they might have a match
def find_match(p1, p2):
    COLORS = ['black', 'dark-blue', 'red', 'orange', 'yellow', 'light-blue', 'green', 'grey', 'brown', ]

    # Create a dictionary to store the similarity information
    SIMILARITIES = {}

    # Associate some items as similar
    SIMILARITIES['black'] = ['brown', 'grey', 'dark-blue']
    SIMILARITIES['dark-blue'] = ['black', 'light-blue']
    SIMILARITIES['red'] = ['orange', 'yellow']
    SIMILARITIES['orange'] = ['red', 'yellow']
    SIMILARITIES['yellow'] = ['orange', 'red']
    SIMILARITIES['light-blue'] = ['dark-blue', 'grey']
    SIMILARITIES['green'] = []
    SIMILARITIES['grey'] = ['black', 'light-blue', 'dark-blue']
    SIMILARITIES['brown'] = ['black', 'dark-blue']
    if p1[2] != p2[2]:
        #   print("same type")
        return False
    elif p1[3] not in SIMILARITIES[p2[3]] and p1[3] != p2[3]:
        #  print("same color")
        return False
    elif p1[4] != p2[4]:
        # print("same cond")
        return False
    return True


# gets the products from the DB
def get_products(conn1, conn2):
    cursor1 = conn1.execute("SELECT * from losses_db")
    cursor2 = conn2.execute("SELECT * from findings_db")

    for row in cursor1:
        loses.add((row[0], row[1], row[2], row[3], row[4]))
    for row in cursor2:
        founds.add((row[0], row[1], row[2], row[3], row[4]))


if __name__ == "__main__":
    print("server start")
    connection = sqlite3.connect("user.db")
    cursor = connection.cursor()
    command = """CREATE TABLE IF NOT EXISTS users_db(username TEXT PRIMARY KEY NOT NULL, password TEXT NOT NULL, 
                            email Text NOT NULL, users_list Text NOT NULL) """
    cursor.execute(command)

    connection1 = sqlite3.connect("loss.db")
    cursor1 = connection1.cursor()
    command1 = """CREATE TABLE IF NOT EXISTS losses_db(id TEXT PRIMARY KEY NOT NULL, username TEXT NOT NULL, 
                                type Text NOT NULL, color Text NOT NULL, condition Text NOT NULL) """
    cursor1.execute(command1)

    connection2 = sqlite3.connect("found.db")
    cursor2 = connection2.cursor()
    command2 = """CREATE TABLE IF NOT EXISTS findings_db(id TEXT PRIMARY KEY NOT NULL, username TEXT NOT NULL, 
                                    type Text NOT NULL, color Text NOT NULL, condition Text NOT NULL) """
    cursor2.execute(command2)
    asyncio.run(main())
