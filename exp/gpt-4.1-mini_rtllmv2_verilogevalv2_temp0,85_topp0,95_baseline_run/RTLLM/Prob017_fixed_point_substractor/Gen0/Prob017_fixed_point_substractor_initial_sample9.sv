module fixed_point_subtractor #
(
    parameter Q = 8,       // Number of fractional bits
    parameter N = 16       // Total number of bits (integer + fractional)
)
(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    // Function to get absolute value of a two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val + 1'b1);
            else
                abs_val = val;
        end
    endfunction

    // Function to perform two's complement (negate)
    function [N-1:0] twos_comp;
        input [N-1:0] val;
        begin
            twos_comp = ~val + 1'b1;
        end
    endfunction

    // Compare magnitudes: returns 1 if a_mag >= b_mag else 0
    function compare_mag;
        input [N-1:0] a_mag;
        input [N-1:0] b_mag;
        begin
            compare_mag = (a_mag >= b_mag) ? 1'b1 : 1'b0;
        end
    endfunction

    always @(*) begin
        // Extract sign bits
        wire sign_a = a[N-1];
        wire sign_b = b[N-1];

        // Calculate magnitudes
        reg [N-1:0] a_mag;
        reg [N-1:0] b_mag;
        a_mag = abs_val(a);
        b_mag = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign subtraction: res_mag = a_mag - b_mag
            if (a_mag >= b_mag) begin
                res = a_mag - b_mag;
                // result sign same as inputs
                if (sign_a == 1'b1)
                    res = twos_comp(res);
            end
            else begin
                res = b_mag - a_mag;
                // result sign is same as inputs, but since subtraction flips,
                // we assign the sign of b (which is same as a)
                if (sign_a == 1'b0)
                    res = twos_comp(res);
                else
                    ; // res already positive in two's comp form, so negate
                // But actually if a_mag < b_mag and signs same,
                // result sign flips - so to be correct:
                // If inputs negative and a_mag < b_mag => result positive
                // If inputs positive and a_mag < b_mag => result negative
                // So sign is sign of bigger magnitude operand
                // Simplify by treating result sign as sign of bigger magnitude operand:
                if (sign_a == 1'b0) // positive inputs
                    res = twos_comp(res); // negate result
                else
                    ; // negative inputs, res positive
            end
        end else begin
            // Different sign: result = a_mag + b_mag
            reg [N-1:0] sum_mag;
            reg res_sign;

            sum_mag = a_mag + b_mag;

            // Determine sign of result
            // If a positive and b negative:
            //   sign = sign of operand with larger magnitude
            // If a negative and b positive:
            //   same logic

            if (sign_a == 1'b0 && sign_b == 1'b1) begin
                // a positive, b negative
                if (a_mag >= b_mag)
                    res_sign = 1'b0;
                else
                    res_sign = 1'b1;
            end else begin
                // a negative, b positive
                if (a_mag >= b_mag)
                    res_sign = 1'b1;
                else
                    res_sign = 1'b0;
            end

            if (res_sign == 1'b1)
                res = twos_comp(sum_mag);
            else
                res = sum_mag;
        end

        // Handle zero: if result is zero, set sign bit to 0 explicitly
        if (res == {N{1'b0}})
            res[N-1] = 1'b0;

        c = res;
    end

endmodule