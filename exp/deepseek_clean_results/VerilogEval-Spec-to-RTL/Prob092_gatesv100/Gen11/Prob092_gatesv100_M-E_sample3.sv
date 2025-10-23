module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Circular left shift (in[0] moves to in[99] position)
    wire [99:0] left_shifted = {in[98:0], in[99]};

    // Mask for boundary bits (all 1s except MSB for out_both, LSB for out_any)
    wire [99:0] both_mask = {1'b0, {99{1'b1}};
    wire [99:0] any_mask = {{99{1'b1}}, 1'b0};

    // Compute outputs in parallel using shifted version
    assign out_both = (in & left_shifted) & both_mask;
    assign out_any = (in | left_shifted) & any_mask;
    assign out_different = in ^ left_shifted;

endmodule