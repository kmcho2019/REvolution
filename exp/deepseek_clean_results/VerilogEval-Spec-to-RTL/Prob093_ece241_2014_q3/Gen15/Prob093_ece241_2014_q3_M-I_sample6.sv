module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: 0 when cd=00, 1 otherwise
    assign mux_in[0] = c | d;

    // ab=01: 1 only when cd=01
    assign mux_in[1] = ~c & d;

    // ab=11: 0 when cd=00 or 01, 1 when cd=11 or 10
    assign mux_in[2] = c;

    // ab=10: 1 when cd=00,10,11; 0 when cd=01
    assign mux_in[3] = c | ~d;

endmodule