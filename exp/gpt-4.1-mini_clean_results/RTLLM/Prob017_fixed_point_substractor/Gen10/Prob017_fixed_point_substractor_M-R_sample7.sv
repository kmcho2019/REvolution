module fixed_point_subtractor #(
    parameter Q = 8,          // Number of fractional bits
    parameter N = 16          // Total number of bits (integer + fractional)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold the result
    reg [N-1:0] res;

    // Sign extraction (MSB)
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Magnitude extraction (absolute values)
    wire [N-2:0] mag_a = sign_a ? (~a[N-2:0] + 1) : a[N-2:0];
    wire [N-2:0] mag_b = sign_b ? (~b[N-2:0] + 1) : b[N-2:0];

    // Intermediate variables for magnitude operations
    reg [N-2:0] mag_res;
    reg sign_res;

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: subtract magnitudes
            if (mag_a >= mag_b) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a;
            end else begin
                mag_res = mag_b - mag_a;
                sign_res = sign_b;
            end
        end else begin
            // Different signs: add magnitudes
            mag_res = mag_a + mag_b;
            // Sign determination:
            // If a positive and b negative
            if (!sign_a && sign_b) begin
                // Result sign depends on which magnitude is greater
                if (mag_a >= mag_b)
                    sign_res = 1'b0;
                else
                    sign_res = 1'b1;
            end else if (sign_a && !sign_b) begin
                if (mag_b >= mag_a)
                    sign_res = 1'b0;
                else
                    sign_res = 1'b1;
            end else begin
                // Should not happen, default to positive
                sign_res = 1'b0;
            end
        end

        // If result magnitude is zero, clear sign bit
        if (mag_res == 0) begin
            res = {1'b0, {(N-1){1'b0}}};
        end else begin
            // Reconstruct result with sign and magnitude
            if (sign_res) begin
                // Negative: two's complement magnitude
                res = {1'b1, (~mag_res + 1)};
            end else begin
                // Positive: direct magnitude
                res = {1'b0, mag_res};
            end
        end
    end

    always @(*) begin
        c = res;
    end

endmodule