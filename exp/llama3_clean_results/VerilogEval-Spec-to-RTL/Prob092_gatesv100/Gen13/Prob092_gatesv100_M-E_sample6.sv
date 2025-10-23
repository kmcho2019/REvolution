module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] in_shifted_left;
    wire [99:0] in_shifted_right;
    wire [99:0] in_shifted_circular;

    // Shift input vector one bit to the left for out_any
    assign in_shifted_left = {in[98:0], 1'b0};

    // Shift input vector one bit to the right for out_both
    assign in_shifted_right = {1'b0, in[99:1]};

    // Circular shift for out_different (wrap-around)
    assign in_shifted_circular = {in[0], in[99:1]};

    // Calculate out_both
    assign out_both = in & in_shifted_right;

    // Calculate out_any
    assign out_any = in | in_shifted_left;

    // Calculate out_different
    assign out_different = in ^ in_shifted_circular;

endmodule