module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,        // First fixed-point operand
    input  wire [N-1:0] b,        // Second fixed-point operand
    output wire [N-1:0] c         // Result of fixed-point addition
);

    reg [N-1:0] res;              // Internal register for result

    // Internal signals for sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute absolute value in two's complement fixed point
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            // If sign bit is 1, negate to get absolute value
            abs_val = val[N-1] ? (~val + 1'b1) : val;
        end
    endfunction

    // Absolute values of inputs
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Comparison of absolute values
    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    // Intermediate sum or difference (width N+1 to prevent overflow in subtraction)
    reg [N:0] abs_add_sub;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            abs_add_sub = {1'b0, a_abs} + {1'b0, b_abs};
            // Saturate if overflow beyond N bits (optional, here we just truncate)
            // Result sign same as inputs' sign
            // If overflow beyond N bits (bit N), result saturates or wraps (here wrap)
            res = abs_add_sub[N-1:0];
            res[N-1] = a_sign; // set sign bit
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs_ge_b_abs) begin
                abs_add_sub = {1'b0, a_abs} - {1'b0, b_abs};
                // If result zero, sign is 0 (positive), else sign of a
                if (abs_add_sub[N-1:0] == 0) begin
                    res = 0;
                end else begin
                    res = abs_add_sub[N-1:0];
                    res[N-1] = 1'b0; // According to problem: MSB=0 if a>b, positive result
                end
            end else begin
                abs_add_sub = {1'b0, b_abs} - {1'b0, a_abs};
                // If result zero, sign is 0; else sign set accordingly (problem states sign bit set to zero or negative)
                if (abs_add_sub[N-1:0] == 0) begin
                    res = 0;
                end else begin
                    res = abs_add_sub[N-1:0];
                    // Since b is larger and signs differ, result sign equals b_sign (negative if b negative)
                    res[N-1] = b_sign;
                end
            end
        end
    end

    // Output assignment
    assign c = res;

endmodule