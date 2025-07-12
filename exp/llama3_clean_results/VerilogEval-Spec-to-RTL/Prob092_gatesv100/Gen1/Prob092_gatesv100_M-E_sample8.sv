module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] in_shifted_left;  // Shifted input vector to the left
    wire [99:0] in_shifted_right; // Shifted input vector to the right

    // Shift input vector to the left by one bit
    assign in_shifted_left = {1'b0, in[99:1]};

    // Shift input vector to the right by one bit
    assign in_shifted_right = {in[98:0], 1'b0};

    // Calculate out_both
    assign out_both = in & in_shifted_left;

    // Calculate out_any
    assign out_any = in | in_shifted_right;

    // Calculate out_different
    assign out_different = in ^ in_shifted_left;

endmodule