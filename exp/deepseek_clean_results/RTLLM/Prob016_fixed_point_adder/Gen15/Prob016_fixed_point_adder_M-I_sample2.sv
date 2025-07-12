module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    
    // Sign logic
    wire signs_eq = (a_sign == b_sign);
    wire res_sign = signs_eq ? a_sign : 
                  (a_gt_b ? a_sign : b_sign);

    // Absolute value arithmetic
    wire [N-1:0] abs_a = {1'b0, a_mag};
    wire [N-1:0] abs_b = {1'b0, b_mag};
    wire [N-1:0] sum = abs_a + abs_b;
    wire [N-1:0] diff = a_gt_b ? (abs_a - abs_b) : (abs_b - abs_a);
    
    // Result selection and overflow detection
    wire [N-1:0] unsigned_res = signs_eq ? sum : diff;
    wire overflow = sum[N-1];  // Carry-out indicates overflow
    
    // Saturation logic
    wire [N-1:0] saturated = {res_sign, {(N-1){~res_sign}}};
    
    // Final output
    assign c = overflow ? saturated : 
               {res_sign, unsigned_res[N-2:0]};

endmodule