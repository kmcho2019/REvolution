module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] in_shifted_left;
    wire [99:0] in_shifted_right;

    assign in_shifted_left = {in[98:0], 1'b0}; // Shift input to the left
    assign in_shifted_right = {1'b0, in[99:1]}; // Shift input to the right

    assign out_both = in & in_shifted_left; // Calculate out_both
    assign out_any = in | in_shifted_right; // Calculate out_any
    assign out_different = in ^ {in[0], in[99:1]}; // Calculate out_different with wrap-around

endmodule