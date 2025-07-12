`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits (for documentation)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values as unsigned
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Same sign subtraction: result magnitude = a_mag - b_mag
    // Different sign addition: result magnitude = a_mag + b_mag

    wire same_sign = (a_sign == b_sign);

    // Intermediate magnitudes and sign determination
    wire [N-1:0] sub_mag_ext = {1'b0, a_mag} - {1'b0, b_mag};  // 1 extra bit for overflow
    wire [N-1:0] add_mag_ext = {1'b0, a_mag} + {1'b0, b_mag};

    // Result magnitude and sign registers
    reg [N-2:0] res_mag;
    reg res_sign;

    // Combinational logic block for determining result magnitude and sign
    always @* begin
        if (same_sign) begin
            // a and b same sign -> subtract magnitudes
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;  // same sign as inputs
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = ~a_sign; // opposite sign because result negative
            end
        end else begin
            // different signs -> add magnitudes
            if (a_mag >= b_mag) begin
                res_mag = a_mag + b_mag;
                res_sign = a_sign;
            end else begin
                res_mag = a_mag + b_mag;
                res_sign = b_sign;
            end
        end

        // Handle zero result: force sign to 0
        if (res_mag == 0)
            res_sign = 1'b0;
    end

    // Convert back to two's complement representation
    // If sign is 1, magnitude is negated
    wire [N-1:0] res_signed = res_sign ? ({1'b0, ~res_mag} + 1'b1) : {1'b0, res_mag};

    // Output assignment
    assign c = res_signed;

endmodule