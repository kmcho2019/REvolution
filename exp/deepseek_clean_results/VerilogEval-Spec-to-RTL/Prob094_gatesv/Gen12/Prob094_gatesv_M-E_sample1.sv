module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create circular left-shifted version of input
    wire [3:0] left_shifted = {in[2:0], in[3]};

    // Generate all neighbor relationships in parallel
    wire [3:0] both_condition = in & left_shifted;
    wire [3:0] any_condition = in | left_shifted;
    wire [3:0] diff_condition = in ^ left_shifted;

    // Apply masks for edge cases and assign outputs
    assign out_both = {1'b0, both_condition[2:0]};
    assign out_any = {any_condition[3:1], 1'b0};
    assign out_different = diff_condition;

endmodule