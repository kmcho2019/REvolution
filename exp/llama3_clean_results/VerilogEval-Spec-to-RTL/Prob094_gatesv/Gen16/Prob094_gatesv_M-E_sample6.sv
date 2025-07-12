module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    wire [3:0] in_shifted_right;
    wire [3:0] in_shifted_left;

    // Shift the input vector to the right by one bit
    assign in_shifted_right = {in[2:0], 1'b0};

    // Shift the input vector to the left by one bit
    assign in_shifted_left = {1'b0, in[3:1]};

    // Compute out_both by performing bitwise AND between the original and shifted-right vectors
    assign out_both = in & in_shifted_right;

    // Compute out_any by performing bitwise OR between the original and shifted-left vectors
    assign out_any = in | in_shifted_left;

    // Compute out_different by performing bitwise XOR between the original and shifted-right vectors
    assign out_different = in ^ {in[0], in[3:1]}; // Wrap-around for the most significant bit

    // Set the unused bits to 0
    assign out_both[3] = 1'b0;
    assign out_any[0] = in[0];
endmodule