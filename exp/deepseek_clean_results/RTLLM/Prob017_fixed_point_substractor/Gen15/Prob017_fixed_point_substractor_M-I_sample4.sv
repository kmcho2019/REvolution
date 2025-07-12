module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total bit width
) (
    input wire [N-1:0] a,  // First fixed-point operand
    input wire [N-1:0] b,  // Second fixed-point operand
    output wire [N-1:0] c  // Subtraction result
);

    // Internal signals
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N-1:0] res;
    wire zero_result;
    
    // Core subtraction
    assign res = a_signed - b_signed;
    
    // Zero detection (all bits zero)
    assign zero_result = (res == 0);
    
    // Output with zero sign correction
    assign c = zero_result ? {1'b0, res[N-2:0]} : res;

endmodule