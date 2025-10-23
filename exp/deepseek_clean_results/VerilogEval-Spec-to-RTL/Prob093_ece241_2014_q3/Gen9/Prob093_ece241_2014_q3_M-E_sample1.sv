module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00: 1 when cd=01,11,10 → ~(c & ~d)
    wire mux_in_0;
    assign mux_in_0 = c ? 1'b1 : ~d;

    // mux_in[1] for ab=01: always 0
    wire mux_in_1 = 1'b0;

    // mux_in[2] for ab=10: 1 when cd=00,11,10 → ~(~c & d)
    wire mux_in_2;
    assign mux_in_2 = c ? 1'b1 : ~d;

    // mux_in[3] for ab=11: 1 when cd=11 → c & d
    wire mux_in_3;
    assign mux_in_3 = c ? d : 1'b0;

    // Connect outputs in correct order (ab=00 is mux_in[0], ab=01 is mux_in[1], etc.)
    assign mux_in = {mux_in_3, mux_in_2, mux_in_1, mux_in_0};

endmodule