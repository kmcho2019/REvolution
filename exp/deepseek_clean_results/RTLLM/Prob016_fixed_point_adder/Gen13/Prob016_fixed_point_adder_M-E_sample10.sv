module fixed_point_adder #(
    parameter Q = 8,        // Fractional bits
    parameter N = 16        // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Convert to sign-magnitude representation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];

    // Determine operation type and result sign
    wire op_add = (a_sign == b_sign);
    wire res_sign = op_add ? a_sign : 
                   (a_mag > b_mag) ? a_sign : b_sign;

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    
    // Select larger and smaller magnitudes
    wire [N-2:0] larger_mag = a_gt_b ? a_mag : b_mag;
    wire [N-2:0] smaller_mag = a_gt_b ? b_mag : a_mag;

    // Perform the appropriate operation with guard bit
    wire [N-1:0] mag_result;
    assign mag_result = op_add ? 
                       {1'b0, a_mag} + {1'b0, b_mag} :  // Addition
                       {1'b0, larger_mag} - {1'b0, smaller_mag};  // Subtraction

    // Detect overflow (only possible in addition case)
    wire overflow = op_add & mag_result[N-1];

    // Final result assembly
    wire [N-2:0] final_mag = overflow ? {N-1{1'b1}} :  // Saturate on overflow
                             mag_result[N-2:0];
    
    // Convert back to two's complement if negative
    assign c = res_sign ? {1'b1, ~final_mag + 1'b1} : {1'b0, final_mag};

endmodule