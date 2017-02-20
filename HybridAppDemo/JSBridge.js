var onCallback = function(value) {};

function getJsBridge() {
    return {
    call: function(e, c, a) {
        var b = '';
        if (typeof c == 'function') {
            a = c;
            c = {};
        }
        if (typeof a == 'function') {
            window.onCallback = a;
        }
        let d = c;
        c = JSON.stringify(c || {});
        if (window._WKFlag) {
            
            d.funcName = e;
            d = JSON.stringify(d || {});
            b = window.webkit.messageHandlers.H5Bridge.postMessage(d);
            //b = prompt(window._ptWKFlag + e, c);
        } else {
            b = _PutaoH5JSBridge.call(e, c);
        }
        return b;
    }
    }
};
