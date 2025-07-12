`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,      // Total bits including sign bit
    parameter integer Q = 8        // Fractional bits
)(
    input  wire [N-1:0] a,         // Input operand a (two's complement fixed-point)
    input  wire [N-1:0] b,         // Input operand b (two's complement fixed-point)
    output reg  [N-1:0] c          // Output result c (two's complement fixed-point)
);

    // Internal signals
    reg [N-1:0] res;

    // Intermediate variables
    reg sign_a, sign_b;
    reg [N-2:0] mag_a;
    reg [N-2:0] mag_b;

    reg res_sign;
    reg [N-2:0] res_mag;

    reg [N-1:0] pos_val;  // positive magnitude with sign bit 0
    reg [N-1:0] neg_val;  // two's complement negation of magnitude

    // Combinational logic block
    always @* begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute magnitude (absolute value) of a
        if (sign_a == 1'b0) begin
            // positive: magnitude is bits [N-2:0] as is
            mag_a = a[N-2:0];
        end else begin
            // negative: two's complement negate to get magnitude
            mag_a = (~a + 1'b1)[N-2:0];
        end

        // Compute magnitude (absolute value) of b
        if (sign_b == 1'b0) begin
            mag_b = b[N-2:0];
        end else begin
            mag_b = (~b + 1'b1)[N-2:0];
        end

        // Calculate result magnitude and sign according to problem logic
        if (sign_a == sign_b) begin
            // Same sign: subtract magnitudes
            if (mag_a >= mag_b) begin
                res_mag = mag_a - mag_b;
                res_sign = sign_a; // sign same as inputs
            end else begin
                res_mag = mag_b - mag_a;
                // sign same as inputs (as per problem statement)
                res_sign = sign_a;
            end
        end else begin
            // Different signs: add magnitudes
            res_mag = mag_a + mag_b;
            // sign depends on which magnitude is greater or equal
            if (mag_a >= mag_b) begin
                res_sign = sign_a;
            end else begin
                res_sign = sign_b;
            end
        end

        // Handle zero result explicitly: sign bit forced to 0 if magnitude is zero
        if (res_mag == {(N-1){1'b0}}) begin
            res_sign = 1'b0;
        end

        // Convert sign and magnitude to two's complement number:
        // For positive sign, just set sign bit 0 and magnitude bits as is
        // For negative sign, form positive value and then negate it (two's complement)
        pos_val = {1'b0, res_mag};       // positive representation with sign=0
        neg_val = (~pos_val) + 1'b1;    // two's complement negation

        if (res_sign == 1'b0) begin
            res = pos_val;
        end else begin
            res = neg_val;
        end

        // Assign output
        c = res;
    end

endmodule