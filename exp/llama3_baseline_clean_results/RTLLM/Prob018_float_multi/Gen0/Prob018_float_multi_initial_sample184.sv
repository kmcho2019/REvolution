module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent; // exponents of input and output numbers
reg a_sign, b_sign, z_sign; // sign bits for inputs and output
reg [49:0] product; // intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // rounding control bits
reg [23:0] sum; // sum of the mantissas
reg [1:0] state; // state machine

// Reset logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        state <= 0;
    end else if (state == 0) begin // Initialize
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
        counter <= counter + 1;
        state <= 1;
    end else if (state == 1) begin // Check for special cases
        if ((a_exponent == 9'hFF && a_mantissa != 0) || (b_exponent == 9'hFF && b_mantissa != 0)) begin // NaN or infinity
            z_sign <= a_sign ^ b_sign;
            z_exponent <= 9'hFF;
            z_mantissa <= 24'h0;
            z <= {z_sign, z_exponent, z_mantissa};
            state <= 0;
        end else if (a_exponent == 0 || b_exponent == 0) begin // zero or subnormal
            z_sign <= a_sign ^ b_sign;
            z_exponent <= 0;
            z_mantissa <= 24'h0;
            z <= {z_sign, z_exponent, z_mantissa};
            state <= 0;
        end else begin
            counter <= counter + 1;
            state <= 2;
        end
    end else if (state == 2) begin // Multiply mantissas
        product <= {a_mantissa, 26'd0} * {b_mantissa, 26'd0};
        counter <= counter + 1;
        state <= 3;
    end else if (state == 3) begin // Normalize and round
        if (product[49]) begin // mantissa overflow
            z_mantissa <= product[49:26];
            z_exponent <= a_exponent + b_exponent + 1;
        end else begin
            z_mantissa <= product[49:26];
            z_exponent <= a_exponent + b_exponent;
        end
        z_sign <= a_sign ^ b_sign;
        counter <= counter + 1;
        state <= 4;
    end else if (state == 4) begin // Finalize output
        z <= {z_sign, z_exponent, z_mantissa};
        state <= 0;
    end
end

endmodule