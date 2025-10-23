module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    wire [N-2:0] mag_a = sign_a ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] mag_b = sign_b ? ~b[N-2:0] + 1'b1 : b[N-2:0];

    // Operation type detection
    wire same_sign = ~(sign_a ^ sign_b);
    wire a_larger = (mag_a > mag_b);

    // Parallel arithmetic paths
    wire [N-1:0] add_path = {sign_a, mag_a + mag_b};
    wire [N-1:0] sub_path = a_larger ? 
                           {sign_a, mag_a - mag_b} : 
                           {sign_b, mag_b - mag_a};

    // Result selection
    wire [N-1:0] raw_result = same_sign ? add_path : sub_path;

    // Overflow detection and handling
    wire overflow = same_sign & (add_path[N-1] != sign_a);
    wire [N-1:0] saturated = sign_a ? 
                           {1'b1, {(N-1){1'b0}}} :  // Most negative
                           {1'b0, {(N-1){1'b1}}};   // Most positive

    // Final output
    assign c = overflow ? saturated : raw_result;

endmodule