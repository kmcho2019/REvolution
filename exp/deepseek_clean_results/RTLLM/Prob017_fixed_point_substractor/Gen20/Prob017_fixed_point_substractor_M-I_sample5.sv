module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Validate parameters
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Determine operation type (addition or subtraction)
    wire signs_differ = a_sign ^ b_sign;
    
    // Optimized magnitude comparison using parallel prefix
    wire a_gt_b;
    generate
        if (N <= 8) begin : fast_cmp
            assign a_gt_b = (a_mag > b_mag);
        end else begin : prefix_cmp
            // Parallel prefix comparator for better timing
            wire [N-2:0] diff = a_mag - b_mag;
            assign a_gt_b = ~diff[N-2];
        end
    endgenerate

    // Core arithmetic operation with optimized operand preparation
    wire [N-1:0] operand_b = signs_differ ? {1'b0, b_mag} : ~{1'b0, b_mag} + 1;
    wire [N-1:0] raw_result = {1'b0, a_mag} + operand_b;
    
    // Simplified overflow detection
    wire result_overflow = raw_result[N-1] & ~signs_differ;
    
    // Result sign calculation
    wire result_sign = signs_differ ? 
                      (a_sign ? ~a_gt_b : a_gt_b) : 
                      a_sign;

    // Optimized zero detection
    wire is_zero = ~(|raw_result[N-2:0]);
    wire final_sign = is_zero ? 1'b0 : (result_overflow ? a_sign : result_sign);

    // Overflow handling with saturation
    wire [N-1:0] saturated = {final_sign, {(N-1){~final_sign}}};
    
    // Final result assembly
    assign c = (result_overflow | is_zero) ? 
               (is_zero ? {1'b0, {N-1{1'b0}}} : saturated) : 
               {final_sign, raw_result[N-2:0]};

endmodule