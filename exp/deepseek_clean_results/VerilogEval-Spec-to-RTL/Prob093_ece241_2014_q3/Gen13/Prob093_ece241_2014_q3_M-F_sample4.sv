module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: 0 when cd=00, 1 otherwise (OR function)
    assign mux_in[0] = c | d;

    // ab=01: 1 when cd=01, 0 otherwise (AND of ~c and d)
    assign mux_in[1] = ~c & d;

    // ab=11: 0 when cd=00 or 01, 1 otherwise (AND function)
    assign mux_in[2] = c & d;

    // ab=10: 1 when cd=00,10,11; 0 when cd=01 (OR of ~d and c)
    assign mux_in[3] = ~d | c;

endmodule