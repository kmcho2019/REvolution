module fixed_point_subtractor #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (integer + fractional)
)(
    input  wire [N-1:0] a,     // First fixed-point operand (signed two's complement)
    input  wire [N-1:0] b,     // Second fixed-point operand (signed two's complement)
    output reg  [N-1:0] c      // Result of subtraction (a - b)
);

    // Extract sign bits (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values:
    // If sign is 1 (negative), absolute value = two's complement
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare magnitudes
    wire a_ge_b = (a_abs >= b_abs);

    reg [N-1:0] mag_res;     // magnitude result of subtraction/addition
    reg         res_sign;    // sign of the result: 0 = positive, 1 = negative

    // Zero detection for magnitude
    wire zero_detect;

    assign zero_detect = ~|mag_res; // reduction NOR: 1 if mag_res == 0

    always @* begin
        // Determine magnitude and sign of result based on input signs

        if (a_sign == b_sign) begin
            // Same sign inputs: perform subtraction of magnitudes
            // Sign of result is same as input sign if a_abs >= b_abs
            // Otherwise sign is inverted
            if (a_ge_b) begin
                mag_res  = a_abs - b_abs;
                res_sign = a_sign;
            end else begin
                mag_res  = b_abs - a_abs;
                res_sign = ~a_sign;
            end
        end else begin
            // Different sign inputs: perform addition of magnitudes
            mag_res = a_abs + b_abs;

            // If a positive, b negative: result sign depends on which magnitude is greater
            // If a negative, b positive: result sign is opposite
            if (~a_sign && b_sign) begin
                // a positive, b negative
                res_sign = a_ge_b ? 1'b0 : 1'b1;
            end else begin
                // a negative, b positive
                res_sign = a_ge_b ? 1'b1 : 1'b0;
            end
        end

        // Construct final result with correct sign and zero handling
        if (zero_detect) begin
            c = {N{1'b0}}; // zero with sign bit = 0 explicitly
        end else if (res_sign) begin
            // Negative result: two's complement of magnitude
            c = (~mag_res) + 1'b1;
        end else begin
            // Positive result: magnitude as is
            c = mag_res;
        end
    end

endmodule