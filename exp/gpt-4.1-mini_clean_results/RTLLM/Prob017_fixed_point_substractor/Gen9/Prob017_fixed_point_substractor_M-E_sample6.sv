module fixed_point_subtractor #(
    parameter Q = 8,              // Number of fractional bits
    parameter N = 16              // Total bits (including sign)
)(
    input  wire [N-1:0] a,       // Fixed-point input operand
    input  wire [N-1:0] b,       // Fixed-point input operand
    output reg  [N-1:0] c        // Fixed-point subtraction result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract magnitudes (absolute values), excluding sign bit
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Magnitude comparison
    wire a_greater_eq_b = (a_mag >= b_mag);

    // Result magnitude register
    reg [N-2:0] res_mag;

    // Result sign bit
    reg res_sign;

    // Combine sign and magnitude to form signed value
    function [N-1:0] combine_sign_mag;
        input sign_bit;
        input [N-2:0] mag_in;
        begin
            if(sign_bit) begin
                // Negative: two's complement representation
                combine_sign_mag = {1'b1, (~mag_in + 1'b1)};
            end else begin
                // Positive: sign bit zero and magnitude as is
                combine_sign_mag = {1'b0, mag_in};
            end
        end
    endfunction

    // Main subtraction/addition logic based on sign of inputs
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_greater_eq_b) begin
                res_mag  = a_mag - b_mag;
                res_sign = a_sign; // same sign as inputs
            end else begin
                res_mag  = b_mag - a_mag;
                res_sign = ~a_sign; // opposite sign of inputs
            end
        end else begin
            // Different signs: add magnitudes
            res_mag  = a_mag + b_mag;
            if (!a_sign) begin
                // a positive, b negative
                res_sign = 1'b0; // result positive
            end else begin
                // a negative, b positive
                res_sign = 1'b1; // result negative
            end
        end

        // Handle zero result: force sign bit to zero
        if (res_mag == 0) begin
            c = {1'b0, {(N-1){1'b0}}};
        end else begin
            c = combine_sign_mag(res_sign, res_mag);
        end
    end

endmodule