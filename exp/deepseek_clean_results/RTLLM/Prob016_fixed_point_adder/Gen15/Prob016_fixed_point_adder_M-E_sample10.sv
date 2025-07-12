module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Sign and magnitude decomposition
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_larger = (a_mag > b_mag);
    
    // Unified arithmetic path
    wire [N-1:0] magnitude_result;
    wire result_sign;
    wire [N-1:0] arithmetic_result;
    
    // Arithmetic operation selection
    assign {magnitude_result, result_sign} = 
        (a_sign == b_sign) ? 
            { {1'b0, a_mag} + {1'b0, b_mag}, a_sign } :  // Same sign: add
            a_larger ? 
                { {1'b0, a_mag - b_mag}, a_sign } :       // Different signs, a larger
                { {1'b0, b_mag - a_mag}, b_sign };        // Different signs, b larger

    // Final result with sign
    assign arithmetic_result = {result_sign, magnitude_result[N-2:0]};
    
    // Overflow detection (only possible when signs match)
    wire carry_out = magnitude_result[N-1];
    assign overflow = (a_sign == b_sign) & carry_out;
    
    // Output assignment
    assign c = arithmetic_result;

endmodule