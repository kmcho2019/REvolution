module fixed_point_adder #(
    parameter Q = 8,               // Number of fractional bits
    parameter N = 16               // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,        // First fixed-point operand
    input  wire [N-1:0] b,        // Second fixed-point operand
    output reg  [N-1:0] c         // Result of addition
);

    // Internal register to hold result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract magnitude (absolute values) by clearing sign bit and adjusting for two's complement
    // Since inputs are in two's complement form, to get magnitude we need to conditionally invert and add 1 if negative
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0) begin
                abs_val = val;
            end else begin
                abs_val = (~val) + 1'b1;
            end
        end
    endfunction

    // Compare absolute values (unsigned)
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: result sign same, add absolute values
            res = abs_a + abs_b;
            // Check overflow - if addition produces carry-out for magnitude, it will naturally wrap
            // since res is N bits, carry out discarded (typical in fixed width)
            // Set result sign bit
            res[N-1] = a_sign;
            // If addition overflowed beyond N bits, it will be lost - this matches typical fixed-point addition behavior
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_a >= abs_b) begin
                res = abs_a - abs_b;
                // Result sign is sign of a (since abs_a >= abs_b)
                res[N-1] = a_sign;
                if (res == 0)
                    res[N-1] = 1'b0; // zero is positive zero
            end else begin
                res = abs_b - abs_a;
                // Result sign is sign of b (since abs_b > abs_a)
                res[N-1] = b_sign;
                if (res == 0)
                    res[N-1] = 1'b0; // zero is positive zero
            end
        end

        // Assign result to output
        c = res;
    end

endmodule