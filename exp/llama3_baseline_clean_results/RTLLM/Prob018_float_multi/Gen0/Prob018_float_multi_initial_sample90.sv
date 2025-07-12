`timescale 1ns / 1ps

module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        z_mantissa <= 24'b0;
        a_exponent <= 8'b0;
        b_exponent <= 8'b0;
        z_exponent <= 8'b0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
        product <= 50'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else begin
        // Input Processing
        if (counter == 3'b000) begin
            a_sign <= a[31];
            a_exponent <= a[30:23];
            a_mantissa <= a[22:0];
            b_sign <= b[31];
            b_exponent <= b[30:23];
            b_mantissa <= b[22:0];
            counter <= counter + 1'b1;
        end
        // Special Cases Handling
        else if (counter == 3'b001) begin
            if ((a_exponent == 8'b255 && a_mantissa != 24'b0) || (b_exponent == 8'b255 && b_mantissa != 24'b0)) begin
                // NaN or infinity, set result accordingly
                z <= (a_sign || b_sign) ? 32'b7fc00000 : 32'b7f800000;
            end else if (a_exponent == 8'b0 || b_exponent == 8'b0) begin
                // Subnormal or zero, handle accordingly
                z <= (a_sign || b_sign) ? 32'b80000000 : 32'b00000000;
            end else begin
                counter <= counter + 1'b1;
            end
        end
        // Normalization and Multiplication
        else if (counter == 3'b010) begin
            // Normalize mantissas if needed
            if (a_mantissa[23] == 1'b0) begin
                a_mantissa <= {1'b1, a_mantissa[22:0]};
                a_exponent <= a_exponent - 1'b1;
            end
            if (b_mantissa[23] == 1'b0) begin
                b_mantissa <= {1'b1, b_mantissa[22:0]};
                b_exponent <= b_exponent - 1'b1;
            end
            // Multiply mantissas
            product <= {24'b0, a_mantissa} * {24'b0, b_mantissa};
            z_exponent <= a_exponent + b_exponent - 127;
            z_sign <= a_sign ^ b_sign;
            counter <= counter + 1'b1;
        end
        // Rounding and Adjustment
        else if (counter == 3'b011) begin
            // Extract rounding bits
            guard_bit <= product[25];
            round_bit <= product[24];
            sticky <= |product[23:0];
            // Round the result
            if (guard_bit && (round_bit || sticky)) begin
                z_mantissa <= product[49:26] + 1'b1;
                z_exponent <= z_exponent + 1'b1;
            end else begin
                z_mantissa <= product[49:26];
            end
            counter <= counter + 1'b1;
        end
        // Output Generation
        else if (counter == 3'b100) begin
            // Format the result
            if (z_exponent > 255) begin
                // Overflow
                z <= (z_sign) ? 32'b7fc00000 : 32'b7f800000;
            end else if (z_exponent < -126) begin
                // Underflow
                z <= (z_sign) ? 32'b80000000 : 32'b00000000;
            end else begin
                z <= {z_sign, z_exponent, z_mantissa};
            end
            counter <= counter + 1'b1;
        end
    end
end

endmodule