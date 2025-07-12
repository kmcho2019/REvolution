module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Circular left shift (neighbor to left becomes current bit)
    wire [99:0] left_neighbor = {in[0], in[99:1]};

    // Circular right shift (neighbor to right becomes current bit)
    wire [99:0] right_neighbor = {in[98:0], in[99]};

    // Mask for edge cases (MSB for out_both, LSB for out_any)
    wire [99:0] out_both_mask = {1'b0, {99{1'b1}}};
    wire [99:0] out_any_mask = {{99{1'b1}}, 1'b0};

    // Compute outputs using parallel bitwise operations
    assign out_both = (in & left_neighbor) & out_both_mask;
    assign out_any = (in | right_neighbor) & out_any_mask;
    assign out_different = in ^ left_neighbor;

endmodule