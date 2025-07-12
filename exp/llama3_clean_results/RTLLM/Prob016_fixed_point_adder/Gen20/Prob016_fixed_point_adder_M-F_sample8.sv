module fixed_point_adder #(
    parameter N = 16, // Total number of bits
    parameter Q = 8   // Number of fractional bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

    wire signed [N:0] sum; // Extra bit for overflow detection

    // Determine operation based on signs of a and b
    assign sum = (a[N-1] == b[N-1]) ? (a + b) : (a[N-1] == 1'b0) ? (a - b) : (b - a);

    // Check for overflow and underflow
    wire overflow = (sum[N] != 0); // Overflow if most significant bit is set
    wire underflow = (sum == 0 && (a[N-1] != b[N-1])); // Underflow if result is zero and signs were different

    // Construct final result considering overflow and underflow
    assign c = (overflow || underflow) ? ((a[N-1] == 1'b1) ? -1 : 0) : sum[N-1:0]; // Truncate to N bits if no overflow/underflow

endmodule