module fixed_point_subtractor #(
    parameter N = 32,
    parameter Q = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude comparison (unsigned)
    wire a_gt_b = (a[N-2:0] > b[N-2:0]);
    
    // Effective operation selection
    wire do_add = (a_sign ^ b_sign);  // Different signs -> addition
    
    // 2's complement subtraction
    wire [N-1:0] b_operand = do_add ? b : ~b + 1;
    wire [N-1:0] raw_result = a + b_operand;
    
    // Result sign determination
    wire result_sign;
    assign result_sign = (a == b) ? 1'b0 :            // Zero case
                        do_add ? (a_sign & b_sign) :  // Addition case
                        a_sign ? ~a_gt_b :           // Negative subtract
                        a_gt_b;                      // Positive subtract
    
    // Final result assembly
    assign c = (a == b) ? {1'b0, {(N-1){1'b0}}} :    // Zero result
               {result_sign, raw_result[N-2:0]};      // Normal case

endmodule