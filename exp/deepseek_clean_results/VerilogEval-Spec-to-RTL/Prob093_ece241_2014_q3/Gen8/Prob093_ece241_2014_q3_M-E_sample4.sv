module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = 1 when cd=01,11,10 → c ? 1'b1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d (only 1 when both c and d are 1)
    assign mux_in[2] = c & d;

    // mux_in[3] = 1 when cd=00,11,10 → c ? d : ~d
    assign mux_in[3] = c ? d : ~d;

endmodule