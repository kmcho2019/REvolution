module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits and operation type
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire op_add = (a_sign == b_sign);
    
    // Magnitude comparison (unsigned)
    wire a_gt_b = (a[N-2:0] > b[N-2:0]);
    
    // Arithmetic operations
    wire [N-1:0] sum = a + b;
    wire [N-1:0] diff = a_gt_b ? (a - b) : (b - a);
    
    // Result selection and sign determination
    wire [N-1:0] res_mag = op_add ? sum[N-1:0] : diff[N-1:0];
    wire res_sign = op_add ? a_sign : 
                   (a_gt_b ? a_sign : b_sign);
    
    // Overflow detection (carry-out from MSB)
    wire overflow = op_add ? (sum[N-1] != a_sign) : 1'b0;
    
    // Final result with overflow protection (saturate)
    assign c = overflow ? {a_sign, {N-1{~a_sign}}} : {res_sign, res_mag[N-2:0]};

endmodule