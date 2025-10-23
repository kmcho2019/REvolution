`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits including sign
    parameter integer Q = 8    // fractional bits
)(
    input  wire [N-1:0] a,   // fixed-point two's complement input
    input  wire [N-1:0] b,   // fixed-point two's complement input
    output reg  [N-1:0] c    // fixed-point two's complement output
);

    // Internal signals for sign extraction and magnitude
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0]; // magnitude of a
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0]; // magnitude of b

    // Magnitude result registers (N-1 bits because sign is separate)
    reg [N-2:0] mag_res;
    reg res_sign;

    // Zero detection
    wire zero_res;

    always @(*) begin
        // Default values
        mag_res = { (N-1){1'b0} };
        res_sign = 1'b0;

        if (a_sign == b_sign) begin
            // Same sign subtraction: subtract magnitudes, keep the sign
            if (a_mag >= b_mag) begin
                mag_res = a_mag - b_mag;
                res_sign = a_sign;
            end else begin
                mag_res = b_mag - a_mag;
                res_sign = a_sign; // result sign same as inputs
            end
        end else begin
            // Different sign: add magnitudes, sign depends on comparison
            mag_res = a_mag + b_mag;
            // sign determination:
            if (a_sign == 0 && b_sign == 1) begin
                // a positive, b negative
                // If a > b (magnitude), result positive else negative
                if (a_mag >= b_mag) res_sign = 0;
                else res_sign = 1;
            end else if (a_sign == 1 && b_sign == 0) begin
                // a negative, b positive
                // If |a| > b, result negative else positive
                if (a_mag > b_mag) res_sign = 1;
                else res_sign = 0;
            end else begin
                res_sign = 0; // fallback (should not happen)
            end
        end
    end

    // Compose two's complement result from sign and magnitude
    wire [N-1:0] two_comp_res;
    assign two_comp_res = (res_sign) ? ({1'b1, ~mag_res} + 1'b1) : {1'b0, mag_res};

    // Check for zero result (all bits zero)
    assign zero_res = (mag_res == 0);

    always @(*) begin
        if (zero_res) begin
            // explicitly clear sign bit for zero result
            c = {1'b0, {(N-1){1'b0}}};
        end else begin
            c = two_comp_res;
        end
    end

endmodule