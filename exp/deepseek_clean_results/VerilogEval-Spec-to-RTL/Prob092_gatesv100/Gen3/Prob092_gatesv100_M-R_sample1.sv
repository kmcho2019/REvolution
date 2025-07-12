module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Intermediate signals for shifted inputs
    wire [99:0] in_left_shifted = {in[0], in[99:1]};  // For wrap-around left neighbor
    wire [98:0] in_right_shifted = in[98:0];          // For right neighbor (no wrap)

    // out_both logic
    assign out_both[99] = 1'b0;  // Special case for MSB
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any logic
    assign out_any[0] = 1'b0;    // Special case for LSB
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different logic (wrap-around)
    assign out_different = in ^ in_left_shifted;

endmodule