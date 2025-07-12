module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation using assertions
    initial begin
        if (N <= Q) $error("N must be greater than Q");
        if (Q <= 0) $error("Q must be positive");
    end

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude calculations (two's complement)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];
    
    // Determine if signs are equal
    wire signs_equal = ~(a_sign ^ b_sign);
    
    // Compute both possible results in parallel
    wire [N-1:0] same_sign_result = a - b;
    wire [N-1:0] diff_sign_result = {1'b0, a_mag} + {1'b0, b_mag};
    
    // Comparison for sign determination
    wire a_gt_b = (a_mag > b_mag);
    
    // Result selection and sign determination
    wire [N-2:0] result_mag;
    wire result_sign;
    
    assign {result_sign, result_mag} = signs_equal ? same_sign_result :
                                     (a_sign ? (a_gt_b ? {1'b1, diff_sign_result[N-2:0]} : 
                                                  {1'b0, diff_sign_result[N-2:0]}) :
                                     (a_gt_b ? {a_sign, diff_sign_result[N-2:0]} : 
                                               {b_sign, diff_sign_result[N-2:0]});
    
    // Explicit zero handling (sign bit cleared)
    assign c = (result_mag == 0) ? {1'b0, {N-1{1'b0}}} : {result_sign, result_mag};

endmodule