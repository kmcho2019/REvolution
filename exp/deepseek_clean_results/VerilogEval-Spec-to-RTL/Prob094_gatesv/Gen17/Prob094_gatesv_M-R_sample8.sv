module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both assignments (bits 2:0 only)
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0;

    // out_any assignments (bits 3:1 only)
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];
    assign out_any[0] = 1'b0;

    // out_different assignments (wrap-around)
    assign out_different[0] = in[0] ^ in[3];  // wrap-around case
    assign out_different[1] = in[1] ^ in[0];
    assign out_different[2] = in[2] ^ in[1];
    assign out_different[3] = in[3] ^ in[2];

endmodule