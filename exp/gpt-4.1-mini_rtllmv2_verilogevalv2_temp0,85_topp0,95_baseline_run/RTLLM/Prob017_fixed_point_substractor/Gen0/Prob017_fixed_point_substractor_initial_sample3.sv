module fixed_point_subtractor #(parameter N = 16, parameter Q = 8)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-2:0] a_mag, b_mag;       // Magnitude (without sign bit)
    reg        a_sign, b_sign;      // Sign bits
    reg [N-1:0] abs_a, abs_b;       // Absolute values of a, b in two's complement form (magnitude with sign bit zero)
    reg [N-1:0] mag_result;         // Magnitude result (unsigned)
    reg        result_sign;         // Sign of result
    reg [N-1:0] res;

    // Function to compute absolute value of a signed N-bit two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Function to combine sign and magnitude back to two's complement
    function [N-1:0] sign_mag_to_twos;
        input        s;
        input [N-1:0] mag; // magnitude assumed positive or zero
        reg [N-1:0] tmp;
        begin
            if (mag == 0)
                sign_mag_to_twos = 0; // zero with sign bit 0
            else if (s == 1'b0)
                sign_mag_to_twos = mag; // positive number
            else
                sign_mag_to_twos = (~mag) + 1'b1; // negative number in two's complement
        end
    endfunction

    always @(*) begin
        a_sign = a[N-1];
        b_sign = b[N-1];
        abs_a  = abs_val(a);
        abs_b  = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (abs_a >= abs_b) begin
                mag_result = abs_a - abs_b;
                result_sign = a_sign; // sign same as inputs
            end else begin
                mag_result = abs_b - abs_a;
                // Since signs same, result sign same as inputs but inverted because abs_b > abs_a
                // Actually, result sign same as inputs but since subtraction flips sign if b > a,
                // Result sign = a_sign if a >= b else b_sign. Here a_sign == b_sign, so sign flips.
                // So result sign = a_sign if abs_a >= abs_b else inverted sign.
                // Since same sign, result sign = a_sign if abs_a >= abs_b else inverted a_sign
                // Implement that:
                result_sign = ~a_sign;
            end
        end else begin
            // Different signs: add magnitudes
            mag_result = abs_a + abs_b;
            // Result sign depends on which magnitude is bigger
            if (abs_a >= abs_b)
                result_sign = a_sign;
            else
                result_sign = b_sign;
        end

        // Handle zero result: if mag_result is zero, sign bit = 0
        if (mag_result == 0)
            result_sign = 1'b0;

        res = sign_mag_to_twos(result_sign, mag_result);
        c = res;
    end

endmodule