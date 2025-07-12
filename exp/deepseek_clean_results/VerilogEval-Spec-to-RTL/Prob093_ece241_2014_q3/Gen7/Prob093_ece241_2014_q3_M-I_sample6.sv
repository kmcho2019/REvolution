module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0]: ab=00 (0,1,1,1)
    // Implement as (NOT cd=00) AND (c OR d)
    wire cd_zero = ~(c | d);
    assign mux_in[0] = cd_zero ? 1'b0 : (c | d);

    // mux_in[1]: ab=01 (always 0)
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab=11 (0,0,1,0)
    assign mux_in[2] = c & d;

    // mux_in[3]: ab=10 (1,0,1,1)
    // Implement as 1 when cd=00, otherwise (c OR ~d)
    assign mux_in[3] = cd_zero ? 1'b1 : (c | ~d);

endmodule