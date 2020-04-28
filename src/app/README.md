# Simple Web app

The project requires the following:
* Golang (1.13+)

And a clone of the project

```
$ git clone https://github.com/carlosroman/payments-api.git
```

The executable can then be found in `checkout_dir/target` and should be called `webapp`.

## Running tests

Open a terminal in the project directory and run:

```
$ make test
```

## Building

Open a terminal in the project directory and run:

```
$ make build
```


## Running the application

After building the application you can run it by opening a terminal in the project dir and running:

```
$ ./target/webapp run -p <port you want to listen on, e.g. 8888>
```

Once it has started you can curl the server and it will respond back:

```
$ curl -v localhost:8888/Bob
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8888 (#0)
> GET /Bob HTTP/1.1
> Host: localhost:8888
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Date: Mon, 06 Apr 2020 12:02:36 GMT
< Content-Length: 11
< Content-Type: text/plain; charset=utf-8
<
* Connection #0 to host localhost left intact
Hello, Bob!
```
