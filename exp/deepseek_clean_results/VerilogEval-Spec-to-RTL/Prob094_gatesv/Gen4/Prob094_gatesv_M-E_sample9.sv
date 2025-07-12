module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create shifted versions of the input
    wire [3:0] left_shifted_in = {in[2:0], 1'b0};  // Left shift (LSB filled with 0)
    wire [3:0] right_shifted_in = {1'b0, in[3:1]}; // Right shift (MSB filled with 0)
    wire [3:0] circular_left_shift = {in[2:0], in[3]}; // Circular left shift

    // out_both: AND with left-shifted version (ignore MSB)
    assign out_both = in & left_shifted_in;
    assign out_both[3] = 1'b0;  // MSB is irrelevant per spec

    // out_any: OR with right-shifted version (ignore LSB)
    assign out_any = in | right_shifted_in;
    assign out_any[0] = 1'b0;   // LSB is irrelevant per spec

    // out_different: XOR with circular left shift
    assign out_different = in ^ circular_left_shift;

endmodule