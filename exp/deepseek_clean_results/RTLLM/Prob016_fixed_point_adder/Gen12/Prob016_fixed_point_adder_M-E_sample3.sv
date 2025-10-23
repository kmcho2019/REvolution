module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude decomposition
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Early sign determination
    wire signs_equal = ~(a_sign ^ b_sign);
    wire a_larger = (a_mag > b_mag);
    wire result_sign = signs_equal ? a_sign : 
                      (a_larger ? a_sign : b_sign);

    // Parallel arithmetic paths
    wire [N-1:0] sum_mag = a_mag + b_mag;  // For same signs
    wire [N-1:0] diff_mag = a_larger ? (a_mag - b_mag) : (b_mag - a_mag);  // For opposite signs

    // Result magnitude selection
    wire [N-1:0] result_mag = signs_equal ? sum_mag : diff_mag;

    // Overflow detection (only possible when signs are equal)
    wire overflow = signs_equal & sum_mag[N-1];

    // Saturation value based on sign
    wire [N-1:0] max_positive = {1'b0, {(N-1){1'b1}};
    wire [N-1:0] max_negative = {1'b1, {(N-1){1'b0}}};

    // Final result assembly
    assign c = overflow ? (result_sign ? max_negative : max_positive) :
               {result_sign, result_mag[N-2:0]};

endmodule