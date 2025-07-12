module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift input vector to the right for out_both and out_any operations
    wire [3:0] in_shifted_right = {in[2:0], 1'b0}; // Shift right by one position, padding with 0

    // Shift input vector to the left for out_any operation
    wire [3:0] in_shifted_left = {in[1:0], in[3:2]}; // Shift left by one position, wrapping around

    // Generate out_both
    assign out_both = in & in_shifted_right;

    // Generate out_any
    assign out_any = in | in_shifted_left;

    // Generate out_different
    assign out_different = in ^ in_shifted_left;

endmodule