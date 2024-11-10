Dos(document.getElementById("dos"), {
    url: dosprog.bundle,
    autoStart: true,
    onEvent: (event, ci) => {
        if (event === "ci-ready") {
            window.ci1 = ci;
            let ppos = location.href.indexOf('?p=');
            if (ppos > 0) {
                let data = atob(location.href.substring(ppos+3));
                if (data.substring(0, 5) == 'https') {
                    let req = new XMLHttpRequest();
                    req.open('GET', data, false);
                    req.send(null);
                    data = (req.status === 200) ? req.responseText : '{error loading file}';
                }
                data = data.replace(/(?<!\r)\n/g, '\r\n');
                ci.fsWriteFile(dosprog.fname, new TextEncoder().encode(data));
            } else {
                ci.fsWriteFile(dosprog.nofile, new TextEncoder().encode("ooops"));
            }
        }
    }});

async function getFile(name) {
    let data = await ci1.fsReadFile(name);
    data = btoa(new TextDecoder().decode(data));
    console.log(data);
}
