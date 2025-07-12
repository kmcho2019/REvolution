module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [1:0] state;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        a_mantissa <= 0;
        b_mantissa <= 0;
        z_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        z_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
        z_sign <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin
                // Extract mantissas, exponents, and sign bits from inputs
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a_sign ^ b_sign;
                // Check for NaN or infinity
                if (a_exponent == 9'hFF || b_exponent == 9'hFF) begin
                    // Handle NaN or infinity
                    if (a_exponent == 9'hFF) begin
                        z <= a;
                    end else if (b_exponent == 9'hFF) begin
                        z <= b;
                    end
                    state <= 0;
                end else begin
                    state <= 1;
                end
            end
            1: begin
                // Multiply mantissas and adjust exponent
                z_mantissa <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 127;
                // Check for overflow
                if (z_exponent > 8'h7F) begin
                    z_exponent <= 8'h7F;
                    z_mantissa <= 0;
                end
                state <= 2;
            end
            2: begin
                // Round result and generate final output
                if (z_mantissa[23]) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= 0;
                end
                z <= {z_sign, z_exponent, z_mantissa};
                state <= 0;
            end
        endcase
    end
end

endmodule