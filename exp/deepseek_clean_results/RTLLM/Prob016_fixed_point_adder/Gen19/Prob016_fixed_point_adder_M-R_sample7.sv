module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values (magnitude without sign)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);

    // Case 1: Both positive or both negative
    wire same_sign = ~(a_sign ^ b_sign);
    wire [N-1:0] sum = {a_sign, a_mag} + {b_sign, b_mag};

    // Case 2: Different signs (subtraction)
    wire [N-1:0] diff;
    assign diff = a_gt_b ? {a_sign, (a_mag - b_mag)} : 
                               {b_sign, (b_mag - a_mag)};

    // Final result selection
    assign c = same_sign ? sum : diff;

endmodule