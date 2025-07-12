module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude comparison
    wire b_gt_a = (b[N-2:0] > a[N-2:0]);
    
    // Operation type
    wire op_add = (a_sign == b_sign);
    
    // Arithmetic operation
    wire [N:0] sum = {a_sign, a} + {b_sign, b};
    wire [N:0] diff = b_gt_a ? {b_sign, b} - {a_sign, a} 
                            : {a_sign, a} - {b_sign, b};
    
    // Result selection
    wire [N:0] arith_res = op_add ? sum : diff;
    
    // Sign determination
    wire res_sign;
    assign res_sign = op_add ? a_sign : 
                    (arith_res[N-1:0] == 0) ? 1'b0 : // Zero is always positive
                    (b_gt_a ? b_sign : a_sign);
    
    // Final result
    assign c = res_sign ? ~arith_res[N-1:0] + 1 : arith_res[N-1:0];

endmodule