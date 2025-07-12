module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform direct two's complement subtraction
    wire [N-1:0] raw_result = a - b;
    
    // Detect zero result
    wire result_zero = ~(|raw_result);
    
    // For zero result, ensure positive sign
    assign c = result_zero ? {1'b0, {N-1{1'b0}}} : raw_result;

endmodule