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

    reg [N-1:0] neg_a_full;  // full negation of a
    reg [N-1:0] neg_b_full;  // full negation of b

    reg [N-1:0] pos_val;     // positive magnitude with sign bit 0
    reg [N-1:0] neg_val;     // two's complement negation of magnitude

    always @* begin
        // Extract signs
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute magnitude of a
        if (sign_a == 1'b0) begin
            // a is positive, magnitude is bits [N-2:0]
            mag_a = a[N-2:0];
        end else begin
            // a is negative, compute two's complement negation of full a first
            neg_a_full = (~a) + 1'b1;
            mag_a = neg_a_full[N-2:0];
        end

        // Compute magnitude of b
        if (sign_b == 1'b0) begin
            mag_b = b[N-2:0];
        end else begin
            neg_b_full = (~b) + 1'b1;
            mag_b = neg_b_full[N-2:0];
        end

        // Calculate result magnitude and sign based on sign and magnitude
        if (sign_a == sign_b) begin
            // Same sign: subtract magnitudes
            if (mag_a >= mag_b) begin
                res_mag = mag_a - mag_b;
                res_sign = sign_a; // sign same as inputs
            end else begin
                res_mag = mag_b - mag_a;
                res_sign = sign_a; // as per problem statement, sign same as inputs
            end
        end else begin
            // Different signs: add magnitudes
            res_mag = mag_a + mag_b;
            // Sign depends on which magnitude is greater or equal
            if (mag_a >= mag_b) begin
                res_sign = sign_a;
            end else begin
                res_sign = sign_b;
            end
        end

        // Handle zero result explicitly: if magnitude zero, force sign bit to 0
        if (res_mag == {(N-1){1'b0}}) begin
            res_sign = 1'b0;
        end

        // Convert sign and magnitude to two's complement:
        pos_val = {1'b0, res_mag};       // positive representation with sign bit = 0
        neg_val = (~pos_val) + 1'b1;    // two's complement negation

        if (res_sign == 1'b0) begin
            res = pos_val;
        end else begin
            res = neg_val;
        end

        c = res;
    end

endmodule