module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Perform the subtraction with signed arithmetic
    wire signed [N-1:0] raw_result = a - b;
    
    // Detect zero result (considering fractional bits)
    wire is_zero = (raw_result == 0);
    
    // Handle zero case (set sign bit to 0 while preserving value)
    wire signed [N-1:0] zero_adjusted = is_zero ? {1'b0, raw_result[N-2:0]} : raw_result;
    
    // Basic overflow checking (optional)
    wire overflow = ((a[N-1] == b[N-1]) && (raw_result[N-1] != a[N-1]));
    
    // Final output with overflow protection
    assign c = overflow ? {a[N-1], {N-1{~a[N-1]}}} : zero_adjusted;

endmodule