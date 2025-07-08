module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold the result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute magnitudes (absolute values) for a and b
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Compare magnitudes
    wire a_gt_b = (a_mag > b_mag);
    wire mag_equal = (a_mag == b_mag);

    // Intermediate magnitude result
    reg [N-1:0] mag_res;
    reg res_sign;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: result magnitude = a_mag - b_mag
            if (a_mag >= b_mag) begin
                mag_res = a_mag - b_mag;
                res_sign = a_sign;
            end else begin
                mag_res = b_mag - a_mag;
                res_sign = ~a_sign; // sign flips if b_mag > a_mag
            end
        end else begin
            // Different sign: add magnitudes
            mag_res = a_mag + b_mag;
            // Sign depends on which magnitude is greater, or if equal take a_sign
            if (a_gt_b) begin
                res_sign = a_sign;
            end else if (mag_equal) begin
                // This case means a_mag == b_mag, so sum = a_mag + b_mag is double magnitude,
                // but this only happens if both inputs are zero? Actually no.
                // For different signs, if magnitudes equal, result is sum of magnitudes (non-zero),
                // sign of result depends on a > b, but if equal, choose a_sign.
                res_sign = a_sign;
            end else begin
                res_sign = b_sign;
            end
        end

        // Compose result with sign and magnitude
        if (mag_res == 0) begin
            // Zero result, sign bit forced to 0
            res = {1'b0, {N-1{1'b0}}};
        end else begin
            // Convert magnitude and sign to two's complement
            if (res_sign) begin
                // Negative result: two's complement of magnitude
                res = ~mag_res + 1'b1;
            end else begin
                // Positive result: magnitude as is
                res = mag_res;
            end
        end
    end

    // Output assignment
    always @* begin
        c = res;
    end

endmodule