module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (except for in[3])
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;  // explicitly set unused bit

    // out_any: check current bit or right neighbor (except for in[0])
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;   // explicitly set unused bit

    // out_different: individual XOR assignments for potential power optimization
    assign out_different[3] = in[3] ^ in[0];  // wrap-around
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[0] = in[0] ^ in[1];

endmodule