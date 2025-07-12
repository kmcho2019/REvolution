module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Saturation constants
    localparam MAX_POS = {1'b0, {(N-1){1'b1}}};
    localparam MAX_NEG = {1'b1, {(N-1){1'b0}}};

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude representations (absolute values)
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];

    // Sum calculation with extra bit for overflow detection
    wire [N:0] full_sum = {a_sign, a[N-2:0]} + {b_sign, b[N-2:0]};

    // Overflow occurs when signs are same but result sign differs
    wire overflow = (a_sign == b_sign) && (full_sum[N] != a_sign);

    // Difference calculation
    wire a_larger = (a_mag > b_mag);
    wire [N-2:0] diff = a_larger ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = a_larger ? a_sign : b_sign;

    // Result selection
    wire same_sign = ~(a_sign ^ b_sign);
    wire [N-1:0] sum_result = overflow ? 
                             (a_sign ? MAX_NEG : MAX_POS) : 
                             {full_sum[N], full_sum[N-2:0]};
    wire [N-1:0] diff_result = {diff_sign, diff};

    // Final output
    assign c = same_sign ? sum_result : diff_result;

endmodule