module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal subtraction result
    wire signed [N-1:0] sub_result = a - b;
    
    // Zero detection (all bits except MSB are zero)
    wire is_zero = ~(|sub_result[N-2:0]);
    
    // Final output with zero handling
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : sub_result;

endmodule