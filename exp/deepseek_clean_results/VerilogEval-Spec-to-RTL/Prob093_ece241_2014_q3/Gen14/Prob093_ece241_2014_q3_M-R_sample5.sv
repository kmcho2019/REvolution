module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: 0 when cd=00, 1 otherwise → OR function
    assign mux_in[0] = c | d;

    // ab=01: 1 when cd=01, 0 otherwise → ~c AND d (correct from original)
    assign mux_in[1] = ~c & d;

    // ab=11: 0 when cd=00 or 01, 1 otherwise
    // cd=00: c=0,d=0 → 0
    // cd=01: c=0,d=1 → 0
    // cd=11: c=1,d=1 → 1
    // cd=10: c=1,d=0 → 1
    assign mux_in[2] = c;

    // ab=10: 0 only when cd=01 → c OR ~d (correct from original)
    assign mux_in[3] = c | ~d;

endmodule