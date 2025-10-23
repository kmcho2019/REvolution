module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift input vector to the left to align each bit with its left neighbor
    wire [3:0] in_shifted_left;
    assign in_shifted_left = {in[2:0], 1'b0}; // Shift left by one position, filling the rightmost bit with 0

    // Shift input vector to the right to align each bit with its right neighbor
    wire [3:0] in_shifted_right;
    assign in_shifted_right = {1'b0, in[3:1]}; // Shift right by one position, filling the leftmost bit with 0

    // Compute out_both by performing bitwise AND between input and its left-shifted version
    assign out_both = in & in_shifted_left;

    // Compute out_any by performing bitwise OR between input and its right-shifted version
    assign out_any = in | in_shifted_right;

    // Compute out_different by performing bitwise XOR between input and its left-shifted version (wrapping around for the last bit)
    wire [3:0] in_wrapped;
    assign in_wrapped = {in[0], in[3:1]}; // Wrap around the input vector
    assign out_different = in ^ in_wrapped;

endmodule