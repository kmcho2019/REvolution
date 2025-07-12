module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform direct two's complement subtraction
    wire [N:0] raw_result = {a[N-1], a} - {b[N-1], b};
    
    // Extract magnitude and sign
    wire result_sign = raw_result[N];
    wire [N-1:0] result_mag = raw_result[N-1:0];
    
    // Zero detection (reduction OR)
    wire is_zero = ~(|result_mag);
    
    // Final result assembly
    assign c = is_zero ? {N{1'b0}} : {result_sign, result_mag[N-2:0]};

endmodule