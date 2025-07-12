module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift the input vector to the right for out_both and out_any calculations
    wire [3:0] in_shifted_right = {in[2:0], 1'b0}; // Shift right by 1 bit, filling with 0 on the left
    wire [3:0] in_shifted_left  = {1'b0, in[3:1]}; // Shift left by 1 bit, filling with 0 on the right

    // Calculate out_both by performing bitwise AND between the original input and the shifted input
    assign out_both = in & in_shifted_right;

    // Calculate out_any by performing bitwise OR between the original input and the shifted input
    assign out_any = in | in_shifted_left;

    // Calculate out_different by performing bitwise XOR between the original input and a wrapped version of the input
    wire [3:0] in_wrapped = {in[0], in[3:1]}; // Wrap the input vector around
    assign out_different = in ^ in_wrapped;

endmodule