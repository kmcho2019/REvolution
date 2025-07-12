module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] left_neighbor = {in[0], in[99:1]};  // Rotated right by 1

    assign out_both = in & left_neighbor;
    assign out_both[99] = 1'b0;  // Override MSB as per spec

    assign out_any = in | {in[98:0], 1'b0};  // Right neighbor with LSB=0
    assign out_different = in ^ left_neighbor;

endmodule