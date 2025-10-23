module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] in_shifted_left;
    wire [99:0] in_shifted_right;

    // Shift input vector one bit to the left for 'out_both' calculation
    assign in_shifted_left = {in[98:0], 1'b0}; // Shift left, padding with 0 on the right

    // Shift input vector one bit to the right for 'out_any' calculation
    assign in_shifted_right = {1'b0, in[99:1]}; // Shift right, padding with 0 on the left

    // Calculate 'out_both'
    assign out_both = in & in_shifted_left;

    // Calculate 'out_any'
    assign out_any = in | in_shifted_right;

    // Calculate 'out_different' using XOR operation
    // To handle wrap-around, we concatenate the input vector with itself and shift it
    wire [199:0] in_double = {in, in};
    wire [99:0] in_shifted_left_wrap = in_double[198:99]; // Shifted left, wrapping around
    assign out_different = in ^ in_shifted_left_wrap;

endmodule