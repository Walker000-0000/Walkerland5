window.addEventListener("message", function (event) {
    const data = event.data;

    if (data.action === "openSend") {
        document.getElementById("container").style.display = "block";
        document.getElementById("sendBox").style.display = "block";
        document.getElementById("inboxBox").style.display = "none";
    }

    if (data.action === "openInbox") {
        document.getElementById("container").style.display = "block";
        document.getElementById("sendBox").style.display = "none";

        let html = "";
        data.telegrams.forEach(t => {
            html += `<div class="telegram">
                <b>PO #${t.po_number}</b><br>
                From: ${t.sender}<br><br>
                ${t.message}
            </div>`;
        });

        document.getElementById("inboxBox").innerHTML = html;
        document.getElementById("inboxBox").style.display = "block";
        document.getElementById("mailCount").innerText = "(" + data.telegrams.length + ")";
    }
    
    if (data.action === "close") {
        document.getElementById("container").style.display = "none";
    }
});

function sendTelegram() {
    fetch(`https://${GetParentResourceName()}/sendTelegram`, {
        method: "POST",
        body: JSON.stringify({
            receiver: document.getElementById("receiver").value,
            message: document.getElementById("message").value
        })
    });
}

function closeUI() {
    document.getElementById("container").style.display = "none";
    // Make sure to release NUI focus
    if (typeof SetNuiFocus !== 'undefined') {
        SetNuiFocus(false, false);
    }
    fetch(`https://${GetParentResourceName()}/close`, { method: "POST" });
}



function openSend() {
    document.getElementById("sendBox").style.display = "block";
    document.getElementById("inboxBox").style.display = "none";
}

function openInbox() {
    fetch(`https://${GetParentResourceName()}/requestInbox`, { method: "POST" });
}