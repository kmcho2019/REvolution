module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Signed interpretation of inputs
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Magnitude comparison for zero detection
    wire magnitudes_equal = (a[N-2:0] == b[N-2:0]);
    
    // Main subtraction result
    wire signed [N-1:0] sub_result = a_signed - b_signed;
    
    // Output assignment with zero handling
    assign c = magnitudes_equal ? {N{1'b0}} : sub_result;

endmodule