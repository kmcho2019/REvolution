`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,
    parameter integer Q = 8
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values for a and b
    wire [N-1:0] a_mag = a_sign ? (~a + 1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1) : b;

    // Intermediate result magnitude and sign
    reg [N-1:0] res_mag;
    reg res_sign;

    // Perform operation based on sign combinations
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same signs: subtract magnitudes
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = ~a_sign; // opposite sign when flipped
            end
        end else begin
            // Different signs: add magnitudes
            res_mag = a_mag + b_mag;
            // Sign depends on which magnitude is bigger (sign of the bigger magnitude operand)
            if (a_mag > b_mag) begin
                res_sign = a_sign;
            end else if (b_mag > a_mag) begin
                res_sign = b_sign;
            end else begin
                // If equal, result is zero => sign bit 0
                res_sign = 1'b0;
            end
        end

        // If result magnitude is zero, force sign to 0
        if (res_mag == 0) begin
            res_sign = 1'b0;
        end
    end

    // Convert back to signed two's complement number
    wire [N-1:0] res_twos_comp = (res_sign) ? (~res_mag + 1) : res_mag;

    assign c = res_twos_comp;

endmodule