module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = (a_sign == b_sign);
    
    // Magnitude calculations
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    
    // Arithmetic operations
    wire [N-1:0] sum, diff;
    wire a_gt_b = (a_mag > b_mag);
    
    assign sum = {a_sign, a_mag + b_mag};
    assign diff = a_gt_b ? {1'b0, a_mag - b_mag} : {1'b1, b_mag - a_mag};
    
    // Final result selection
    assign c = signs_equal ? sum : diff;

endmodule