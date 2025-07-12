module fixed_point_subtractor #(
    parameter N = 32   // Total number of bits (minimum 2)
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal signals
    wire signed [N-1:0] raw_diff = a - b;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);
    wire a_gt_b = (a > b);
    
    // Magnitude part (all bits except sign)
    wire [N-2:0] magnitude = raw_diff[N-2:0];
    
    // Sign determination
    wire result_sign;
    assign result_sign = (raw_diff == 0) ? 1'b0 :          // Zero case
                         signs_equal   ? a_sign :          // Same signs
                         a_gt_b        ? 1'b0 : 1'b1;      // Different signs
    
    // Final output assignment
    assign c = {result_sign, magnitude};

endmodule