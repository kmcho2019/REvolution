module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create shifted versions of the input
    wire [3:0] left_shifted = {in[2:0], 1'b0};  // Left shift (LSB filled with 0)
    wire [3:0] right_shifted = {1'b0, in[3:1]}; // Right shift (MSB filled with 0)
    wire [3:0] circular_shifted = {in[0], in[3:1]}; // Circular left shift

    // out_both: AND with left-shifted version (ignore MSB result)
    assign out_both = in & left_shifted;
    assign out_both[3] = 1'b0;  // Per spec, MSB is irrelevant

    // out_any: OR with right-shifted version (ignore LSB result)
    assign out_any = in | right_shifted;
    assign out_any[0] = 1'b0;   // Per spec, LSB is irrelevant

    // out_different: XOR with circular-shifted version
    assign out_different = in ^ circular_shifted;

endmodule