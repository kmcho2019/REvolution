module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform direct two's complement subtraction
    wire [N-1:0] raw_result = a - b;

    // Zero detection (all bits zero)
    wire is_zero = (raw_result == {N{1'b0}});

    // Final result (force positive zero if result is zero)
    assign c = is_zero ? {N{1'b0}} : raw_result;

endmodule