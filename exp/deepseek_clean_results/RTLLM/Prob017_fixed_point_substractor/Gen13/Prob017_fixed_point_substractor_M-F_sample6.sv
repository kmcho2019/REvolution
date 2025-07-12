module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,    // First operand
    input wire [N-1:0] b,    // Second operand
    output wire [N-1:0] c,   // Subtraction result
    output wire overflow     // Overflow detection flag
);

    // Signed intermediate values
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);
    wire signed [N-1:0] result = a_signed - b_signed;

    // Overflow detection
    assign overflow = (a_signed[N-1] == b_signed[N-1]) && 
                     (result[N-1] != a_signed[N-1]);

    // Handle zero result sign explicitly
    wire is_zero = (result == 0);
    wire [N-1:0] adjusted_result = is_zero ? {1'b0, result[N-2:0]} : result;

    // Output assignments
    assign c = adjusted_result;

endmodule