module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire [N-1:0] subtraction_result;
    wire result_sign;
    wire is_zero;
    
    // Perform two's complement subtraction
    assign subtraction_result = a - b;
    
    // Determine result sign
    assign result_sign = subtraction_result[N-1];
    
    // Zero detection (all bits zero)
    assign is_zero = (subtraction_result == {N{1'b0}});
    
    // Final result assembly with explicit zero handling
    assign c = is_zero ? {N{1'b0}} : subtraction_result;

endmodule