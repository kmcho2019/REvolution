module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift input vector to the right to align with left neighbors
    wire [3:0] in_shifted_right = {in[2:0], 1'b0};

    // Shift input vector to the left to align with right neighbors
    wire [3:0] in_shifted_left = {1'b0, in[3:1]};

    // Generate out_both vector using bitwise AND operation
    assign out_both = in & in_shifted_right;

    // Generate out_any vector using bitwise OR operation
    assign out_any = in | in_shifted_left;

    // Generate out_different vector using bitwise XOR operation
    assign out_different = in ^ {in[2:0], in[3]};

endmodule