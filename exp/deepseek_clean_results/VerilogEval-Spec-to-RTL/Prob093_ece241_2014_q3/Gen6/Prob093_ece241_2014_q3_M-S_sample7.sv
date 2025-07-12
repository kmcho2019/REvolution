module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: 0 when cd=00, 1 otherwise (c OR d)
    assign mux_in[0] = c | d;

    // ab=01: always 0
    assign mux_in[1] = 1'b0;

    // ab=11: 1 only when cd=11 (c AND d)
    assign mux_in[2] = c ? d : 1'b0;

    // ab=10: 0 only when cd=01 (~(c & ~d))
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule