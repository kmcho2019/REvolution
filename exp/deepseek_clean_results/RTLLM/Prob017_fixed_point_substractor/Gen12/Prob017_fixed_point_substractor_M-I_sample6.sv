module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal signed result
    wire signed [N-1:0] raw_result = a - b;
    
    // Zero detection (all bits zero)
    wire is_zero = (raw_result == 0);
    
    // Final result with zero handling
    assign c = is_zero ? {1'b0, {(N-1){1'b0}}} : raw_result;

endmodule