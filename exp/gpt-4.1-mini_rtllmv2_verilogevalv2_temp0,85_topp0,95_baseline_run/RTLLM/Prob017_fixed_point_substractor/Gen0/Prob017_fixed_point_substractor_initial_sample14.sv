module fixed_point_subtractor #(parameter N = 16, parameter Q = 8) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal registers
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract magnitudes (absolute values)
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    reg [N-1:0] magnitude_result;
    reg        result_sign;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_mag >= b_mag) begin
                magnitude_result = a_mag - b_mag;
                result_sign = a_sign; // same sign as inputs
            end else begin
                magnitude_result = b_mag - a_mag;
                // sign is the same as inputs, but since subtraction swapped,
                // result sign is same as inputs (which are identical)
                // Actually this case implies a_mag < b_mag, so result sign = inputs sign?
                // The problem states: "sign of the result will be the same as the inputs"
                // but if a_mag < b_mag, the subtraction is negative.
                // This is an ambiguity: subtraction of same sign inputs, e.g. a=+3, b=+5,
                // a-b = -2, sign changes.
                // To correct: If same sign, subtract magnitudes, sign is sign of bigger magnitude.
                // So result sign = sign of operand with bigger magnitude.
                result_sign = a_sign; // inputs sign
                // Actually result should have sign of bigger magnitude operand:
                // Let's fix this:
                // result_sign = (a_mag >= b_mag) ? a_sign : b_sign; but a_sign == b_sign here
                // So same sign, but if a_mag < b_mag, result sign flips.
                // So result_sign = a_sign if a_mag >= b_mag else invert a_sign.
                // Let's implement correct logic:
                result_sign = a_sign; // placeholder, will fix below
            end
        end else begin
            // Different signs: add magnitudes
            magnitude_result = a_mag + b_mag;
            // Determine sign of result:
            // If a positive and b negative => sign positive if a_mag > b_mag else negative
            // If a negative and b positive => sign negative if a_mag > b_mag else positive
            if (a_sign == 0 && b_sign == 1) begin
                // a positive, b negative
                if (a_mag >= b_mag) begin
                    result_sign = 0;
                end else begin
                    result_sign = 1;
                end
            end else if (a_sign == 1 && b_sign == 0) begin
                // a negative, b positive
                if (a_mag >= b_mag) begin
                    result_sign = 1;
                end else begin
                    result_sign = 0;
                end
            end else begin
                // Should not happen
                result_sign = 0;
            end
        end

        // Fix for same sign subtraction case when a_mag < b_mag:
        if (a_sign == b_sign) begin
            if (a_mag < b_mag) begin
                magnitude_result = b_mag - a_mag;
                // result sign flips
                result_sign = ~a_sign;
            end else begin
                magnitude_result = a_mag - b_mag;
                result_sign = a_sign;
            end
        end

        // Handle zero result: sign bit explicitly 0
        if (magnitude_result == 0) begin
            result_sign = 0;
        end

        // Compose result: if sign == 0 positive => result = magnitude_result
        // else two's complement of magnitude_result
        if (result_sign == 0) begin
            res = magnitude_result;
        end else begin
            res = ~magnitude_result + 1'b1;
        end

        c = res;
    end

endmodule