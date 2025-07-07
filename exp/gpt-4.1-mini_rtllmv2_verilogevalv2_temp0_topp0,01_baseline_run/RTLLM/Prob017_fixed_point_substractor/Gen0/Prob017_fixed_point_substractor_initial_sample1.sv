module fixed_point_subtractor #(parameter N = 16, parameter Q = 8) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold result
    reg [N-1:0] res;

    // Extract sign bits (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract magnitudes (absolute values)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Intermediate variables
    reg [N-1:0] mag_result;
    reg result_sign;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_mag >= b_mag) begin
                mag_result = {1'b0, a_mag} - {1'b0, b_mag};
                result_sign = a_sign;
            end else begin
                mag_result = {1'b0, b_mag} - {1'b0, a_mag};
                // Sign same as inputs, but since a_mag < b_mag, result sign flips
                // Actually, for same sign subtraction, result sign is sign of larger magnitude
                result_sign = a_sign; // but a_sign == b_sign, so sign is same
                // But since a_mag < b_mag, result sign should be sign of b (same as a_sign)
                // So result_sign = a_sign is correct
                // But magnitude is b_mag - a_mag
                // So sign is same as inputs
            end
        end else begin
            // Different signs: add magnitudes
            mag_result = {1'b0, a_mag} + {1'b0, b_mag};
            // Result sign depends on which magnitude is larger
            if (a_mag >= b_mag)
                result_sign = a_sign;
            else
                result_sign = b_sign;
        end

        // Handle zero result: if magnitude is zero, sign bit = 0
        if (mag_result[N-2:0] == 0)
            result_sign = 1'b0;

        // Compose final result in two's complement form
        // Convert magnitude and sign back to two's complement
        if (result_sign == 1'b0) begin
            // positive number
            res = {1'b0, mag_result[N-2:0]};
        end else begin
            // negative number: two's complement of magnitude
            res = {1'b1, (~mag_result[N-2:0] + 1'b1)};
        end
    end

    always @(*) begin
        c = res;
    end

endmodule