`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,        // Total bits: sign + integer + fractional
    parameter integer Q = 8          // Number of fractional bits
)(
    input  wire [N-1:0] a,           // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,           // Fixed-point operand b (two's complement)
    output wire [N-1:0] c            // Fixed-point subtraction result (two's complement)
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude extraction (absolute value) as unsigned
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Result signals
    reg [N-1:0] res_mag;
    reg res_sign;

    // Combinational logic for subtraction per problem statement
    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes (a_mag - b_mag)
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign; // result sign same as inputs
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = ~a_sign; // opposite sign since subtracting larger from smaller
            end
        end else begin
            // Different signs: add magnitudes
            res_mag = a_mag + b_mag;
            // Result sign depends on magnitude comparison
            // If a_mag > b_mag => result sign is a_sign (sign of a)
            // else sign of b (since subtraction flips sign)
            if (a_mag > b_mag)
                res_sign = a_sign;
            else if (b_mag > a_mag)
                res_sign = b_sign;
            else
                // If magnitudes equal, result zero => sign=0 per problem
                res_sign = 1'b0;
        end

        // If result magnitude is zero, force sign = 0 (positive zero)
        if (res_mag == 0)
            res_sign = 1'b0;
    end

    // Convert magnitude and sign back to two's complement
    // If sign = 0, output is res_mag as is
    // If sign = 1, output is two's complement negation of res_mag
    wire [N-1:0] res_twos_comp = res_sign ? (~res_mag + 1'b1) : res_mag;

    assign c = res_twos_comp;

endmodule