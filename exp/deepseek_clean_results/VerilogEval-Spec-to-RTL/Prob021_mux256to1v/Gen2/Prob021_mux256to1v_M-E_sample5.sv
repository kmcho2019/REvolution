module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    wire [63:0] stage1_out;
    wire [3:0] stage2_out;

    // First stage: 16:1 mux selecting 64-bit chunks
    assign stage1_out = in[64*sel[7:4] +: 64];

    // Second stage: 16:1 mux selecting 4-bit nibbles within the chunk
    assign stage2_out = stage1_out[4*sel[3:0] +: 4];

    assign out = stage2_out;

endmodule