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
    
    // Prepare operands for core operation
    wire [N-1:0] operand_a = {1'b0, a_mag};
    wire [N-1:0] operand_b = signs_differ ? {1'b0, b_mag} : ~{1'b0, b_mag} + 1;

    // Core arithmetic operation
    wire [N-1:0] raw_result = operand_a + operand_b;
    wire [N-2:0] result_mag = raw_result[N-2:0];
    wire result_overflow = raw_result[N-1];

    // Magnitude comparison for sign determination
    wire a_gt_b = (a_mag > b_mag);
    
    // Result sign calculation
    wire result_sign = signs_differ ? 
                      (a_sign ? ~a_gt_b : a_gt_b) : 
                      a_sign;

    // Zero detection and sign correction
    wire is_zero = ~(|result_mag);  // Efficient OR reduction
    wire final_sign = is_zero ? 1'b0 : result_sign;

    // Overflow handling with proper saturation
    wire [N-1:0] max_pos = {1'b0, {(N-1){1'b1}}};
    wire [N-1:0] max_neg = {1'b1, {(N-1){1'b0}}};
    wire [N-1:0] overflow_result = result_sign ? max_neg : max_pos;
    
    // Final result assembly
    assign c = result_overflow ? overflow_result : 
               {final_sign, result_mag};

endmodule