module hybrid_fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

    // Extract sign and magnitude of inputs
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    wire [N-2:0] mag_a = (sign_a) ? (~a[N-2:0] + 1) : a[N-2:0];
    wire [N-2:0] mag_b = (sign_b) ? (~b[N-2:0] + 1) : b[N-2:0];

    // Dual-path arithmetic for integer and fractional parts
    wire [N-2:0] int_sum;
    wire [Q-1:0] frac_sum;
    assign int_sum = mag_a[N-2:Q] + mag_b[N-2:Q];
    assign frac_sum = mag_a[Q-1:0] + mag_b[Q-1:0];

    // Overflow detection and correction
    wire overflow;
    assign overflow = (int_sum[N-2-Q] == 1) ? 1 : 0;

    // Precision management
    wire [N-1:0] result;
    assign result = (overflow) ? {1, int_sum[N-2-Q:0], frac_sum} : {sign_a, int_sum, frac_sum};

    // Assign output
    assign c = result;

endmodule