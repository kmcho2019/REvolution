module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Common selection signal for cases where we need to detect cd=00
    wire cd_zero = ~(c | d);

    // mux_in[0]: ab=00 (0,1,1,1)
    assign mux_in[0] = cd_zero ? 1'b0 : (c | d);

    // mux_in[1]: ab=01 (always 0)
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab=11 (0,0,1,0)
    assign mux_in[2] = c & d;  // Simple AND operation

    // mux_in[3]: ab=10 (1,0,1,1)
    assign mux_in[3] = cd_zero ? 1'b1 : (c | ~d);

endmodule