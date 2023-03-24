var express = require('express');
var mysql = require('mysql');

var con = mysql.createConnection(
    {
        host: "localhost",
        database: "chatex",
        user: "root",
        password: "123456"
    }
)

con.connect(function (err) {
    if (err) {
        console.log(err);
        throw err;
    }
    console.log("Connected!")
})

var app = express();

const PORT = process.env.PORT || 3000;
var server = app.listen(PORT, function () {
    console.log("node is running succefully..")
})

app.get('/', function (req, res) {
    res.send("<h1>Welcome to chatEx</h1>");
})

//create new user in users table 
app.get("/register/:num", (req, res) => {
    const { num } = req.params; //as a integer stored
    //first we check whether user already exists, if he does then get his contacts and return it
    //if not then create user in DB accordingly

    con.query("select * from users where phone_no = '" + num + "'",
        function (err, result, fields) {
            if (err) {
                console.log(err.code);
                console.log(err.errno);
                console.log(err.sqlMessage);
                res.send("Failed to check for existing user");
            }
            else {
                //if result returns empty then the user is a new user so insert him 
                //else get his contacts
                console.log(result)
                if (result.length == 0) {
                    con.query("insert into users values('" + num + "')"
                        , function (err, result, fields) {
                            if (err) {
                                console.log(err.code);
                                console.log(err.errno);
                                console.log(err.sqlMessage);
                                res.send("Failed to insert data");
                            }
                            else {
                                console.log("Registered user!");
                                //converted number integer to string
                                var num_as_string = num.toString();
                                con.query("create table `" + num_as_string + "`(name varchar(30),contact_number varchar(10) primary key)", function (err, result, fields) {
                                    if (err) {
                                        console.log(err.code);
                                        console.log(err.errno);
                                        console.log(err.sqlMessage);
                                        res.send("Failed to register user");
                                    }
                                    console.log("Registered user!");
                                    // console.log(result);
                                    res.send("True");
                                });
                            }
                        }
                    );
                }
                else {
                    con.query("select * from `" + num + "`",
                        function (err, results, fields) {
                            if (err) {
                                console.log(err.code);
                                console.log(err.errno);
                                console.log(err.sqlMessage);
                                res.send("Failed to return existing user contacts");
                            }
                            else {
                                var contactsarray = []
                                var temparray = []
                                // console.log(results) //displaying all contacts in console
                                results.forEach(element => {
                                    temparray = []
                                    // console.log(element)
                                    temparray.push(element.name)
                                    temparray.push(element.contact_number)
                                    contactsarray.push(temparray)
                                    console.log(contactsarray)
                                })

                                res.send(contactsarray)
                            }
                        }
                    )
                }
            }
        }
    )
});

//create an entry in current user table of new friend contact also create corresponding message table
//akshay add curruser and contact num and pass sumofnums as a string
app.get("/addcontact/:curruser/:name/:num/:sumofnums", (req, res) => {
    const { curruser } = req.params;
    const { name } = req.params;
    const { num } = req.params; //as a integer stored
    const { sumofnums } = req.params;

    //first check whether the contact number exists in our application or not. if exists then continue
    //else show pop up for now return true or false accordingly
    con.query("select * from users where phone_no = '" + num + "'",
        function (err, result, fields) {
            if (err) {
                console.log(err.code);
                console.log(err.errno);
                console.log(err.sqlMessage);
                res.send("Failed to check for existing user");
            }
            else {
                //if result returns empty then the user is a new user so insert him 
                //else get his contacts
                console.log(result)
                if (result.length == 0) {
                    //user is not registered in our application
                    res.send("False") // false means the contact is not registered on our application
                }
                else {
                    //user exist, now check whether you have already added him or not 
                    //so as to avoid duplicate chat
                    //if he is not already ur frnd  so  add him in contacts and create appropriate message table
                    con.query("insert into `" + curruser + "` values('" + name + "', '" + num + "')",
                        function (err, result) {
                            if (err) {
                                console.log(err.sqlMessage)
                                res.send("User already in your contacts")
                            }
                            else {
                                //created sum of both numbers for message table
                                con.query("create table `" + sumofnums + "`(message varchar(200),send_time varchar(30),sender_number varchar(10))"
                                    , function (err, result, fields) {
                                        if (err) {
                                            res.send("Failed to create contact table");
                                            throw err;
                                        }
                                        console.log(result);
                                        res.send("True"); // true means contact is registered and now your friend
                                    }
                                );
                            }
                        }
                    );
                }
            }
        })
});


app.get("/sendmessage/:message/:send_time/:sender/:sumofnums", (req, res) => {
    const { message } = req.params;
    const { send_time } = req.params;
    const { sender } = req.params; //as a integer stored
    const { sumofnums } = req.params;
    con.query("insert into `" + sumofnums + "` values('" + message + "','" + send_time + "','" + sender + "')",
        function (err, result, fields) {
            if (err) {
                res.send("Failed");
            }
            console.log(result);
            res.send("Success");
        }
    );
});


//receive all messages api
app.get("/receivemessages/:sumofnums", (req, res) => {
    const { sumofnums } = req.params

    con.query("select * from `" + sumofnums + "`",
        function (err, results, fields) {
            if (err) {
                console.log(err.code);
                console.log(err.errno);
                console.log(err.sqlMessage);
                res.send("Failed");
            }
            else {
                var messagesarray = []
                var temparray = []
                // console.log(results) //displaying all contacts in console
                results.forEach(element => {
                    temparray = []
                    // console.log(element)
                    temparray.push(element.message)
                    temparray.push(element.send_time)
                    temparray.push(element.sender_number)
                    messagesarray.push(temparray)
                    console.log(messagesarray)
                })

                res.send(messagesarray)
            }
        }
    )


})