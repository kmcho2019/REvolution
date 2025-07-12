module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    assign out_both = {1'b0, in[2:0] & in[3:1]};  // Check current and left neighbor
    assign out_any = {in[3:1] | in[2:0], 1'b0};    // Check current or right neighbor
    assign out_different = in ^ {in[0], in[3:1]};   // Circular XOR with left neighbor

endmodule