const base = window.location.href;
const socketBase = base.replace(/http(s)?/, "ws$1");
const chatPath = socketBase + "chat";

const socket = new WebSocket(chatPath);

socket.onopen = () => {
    console.log("Socket to " + chatPath + " is opened.");
    socket.send(JSON.stringify({user: "Test", message: "This is a message"}));

    socket.onmessage = (evt) => {
        console.log(JSON.parse(evt.data));
    }
}
