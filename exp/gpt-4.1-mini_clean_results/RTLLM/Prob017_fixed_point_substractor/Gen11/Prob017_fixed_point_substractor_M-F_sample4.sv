`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values as unsigned
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    reg [N-1:0] mag_res;   // magnitude result (unsigned)
    reg sign_res;          // result sign

    // Use signed variable for result assembly
    reg signed [N-1:0] res;

    always @(*) begin
        // Default zero
        mag_res = {N{1'b0}};
        sign_res = 1'b0;

        if (a_sign == b_sign) begin
            // Same sign: magnitude subtraction
            if (a_abs >= b_abs) begin
                mag_res = a_abs - b_abs;
                sign_res = a_sign;  // sign same as inputs
            end else begin
                mag_res = b_abs - a_abs;
                sign_res = a_sign;  // sign same as inputs
            end
        end else begin
            // Different sign: magnitude addition
            mag_res = a_abs + b_abs;
            if (!a_sign && b_sign) begin
                // a positive, b negative
                sign_res = (a_abs >= b_abs) ? 1'b0 : 1'b1;
            end else if (a_sign && !b_sign) begin
                // a negative, b positive
                sign_res = (a_abs >= b_abs) ? 1'b1 : 1'b0;
            end else begin
                // Defensive fallback (should never occur)
                sign_res = 1'b0;
            end
        end

        // If magnitude zero, force sign 0 (avoid negative zero)
        if (mag_res == 0) begin
            sign_res = 1'b0;
        end

        // Assemble signed result
        if (sign_res) begin
            // Negative result: two's complement magnitude
            res = -$signed(mag_res);
        end else begin
            // Positive result: direct magnitude
            res = $signed(mag_res);
        end

        c = res;
    end

endmodule