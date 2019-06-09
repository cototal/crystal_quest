const base = window.location.href;
const socketBase = base.replace(/http(s)?/, "ws$1");
const chatPath = socketBase + "chat";

const socket = new WebSocket(chatPath);

socket.onopen = () => {
    console.log("Socket to " + chatPath + " is opened.");
    $commandForm = $("#command-form");
    $story = $("#story");

    socket.send(JSON.stringify({user: "Test", message: "This is a message"}));

    socket.onmessage = (evt) => {
        const data = JSON.parse(evt.data);
        $story.append(`<p>${data.message}</p>`);
    }

    $commandForm.on("submit", evt => {
        evt.preventDefault();
        const $input = $commandForm.find("input[type='text']");
        const action = $input.val();
        socket.send(JSON.stringify({user : "Test", message: action}));
        $input.val("");
    })
}
