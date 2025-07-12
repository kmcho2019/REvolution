module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-1:0] a_mag = a_sign ? -a : a;
    wire [N-1:0] b_mag = b_sign ? -b : b;
    
    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    
    // Absolute addition/subtraction
    wire [N:0] abs_result;
    wire result_sign;
    
    assign {result_sign, abs_result} = (a_sign == b_sign) ? 
                                      {a_sign, a_mag + b_mag} :         // Same sign: add magnitudes
                                      a_gt_b ? 
                                      {a_sign, a_mag - b_mag} :         // a > b: a - b, keep a's sign
                                      {b_sign, b_mag - a_mag};          // b > a: b - a, keep b's sign
    
    // Overflow detection and saturation
    wire overflow = abs_result[N] && (a_sign == b_sign);
    wire [N-1:0] saturated_result = a_sign ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
    
    // Final result selection
    assign c = overflow ? saturated_result : 
               {result_sign, abs_result[N-1:0]};

endmodule