module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total bits including sign bit
)(
    input  wire [N-1:0] a,      // Fixed-point input operand a
    input  wire [N-1:0] b,      // Fixed-point input operand b
    output reg  [N-1:0] c       // Fixed-point addition result
);

    // Internal unsigned magnitudes of operands (N-1 bits)
    reg [N-2:0] mag_a;
    reg [N-2:0] mag_b;

    // Sum and difference of magnitudes (N bits to hold carry/borrow)
    reg [N-1:0] mag_sum;
    reg [N-1:0] mag_diff;

    // Operand sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Result sign
    reg sign_res;

    always @(*) begin
        // Extract magnitudes by zeroing sign bit (two's complement abs is conditional negation,
        // but here we'll compute abs manually)
        // Absolute value in two's complement:
        // If sign=1, abs = (~x[N-2:0] + 1)
        // But we must operate on whole N bits; since we are extracting magnitude,
        // Let's extract magnitude by conditional negation of whole input treated as signed.

        // Compute magnitude of 'a':
        if (sign_a) begin
            // a is negative: abs(a) = (~a + 1)
            mag_a = (~a[N-2:0] + 1'b1);
        end else begin
            mag_a = a[N-2:0];
        end

        // Compute magnitude of 'b':
        if (sign_b) begin
            mag_b = (~b[N-2:0] + 1'b1);
        end else begin
            mag_b = b[N-2:0];
        end

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            mag_sum = mag_a + mag_b;

            // The result sign is same as operands
            sign_res = sign_a;

            // Assign output with sign bit and truncated magnitude (lowest N-1 bits)
            // Overflow carry (mag_sum[N-1]) ignored (wraparound)

            // Compose output:
            c = {sign_res, mag_sum[N-2:0]};
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude

            if (mag_a == mag_b) begin
                // Magnitudes equal, result zero
                c = {1'b0, {(N-1){1'b0}}};
            end else if (mag_a > mag_b) begin
                mag_diff = mag_a - mag_b;
                sign_res = sign_a;  // sign of larger magnitude

                c = {sign_res, mag_diff[N-2:0]};
            end else begin
                mag_diff = mag_b - mag_a;
                sign_res = sign_b;  // sign of larger magnitude

                c = {sign_res, mag_diff[N-2:0]};
            end
        end
    end

endmodule