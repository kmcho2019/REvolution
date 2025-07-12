module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total bit width
) (
    input wire [N-1:0] a,  // First fixed-point operand
    input wire [N-1:0] b,  // Second fixed-point operand
    output wire [N-1:0] c  // Subtraction result
);

    // Internal subtraction result
    wire [N-1:0] raw_res = a - b;
    
    // Zero detection (check all magnitude bits)
    wire zero_result = ~|raw_res[N-2:0];
    
    // Output with zero sign correction
    assign c = zero_result ? {1'b0, raw_res[N-2:0]} : raw_res;

endmodule