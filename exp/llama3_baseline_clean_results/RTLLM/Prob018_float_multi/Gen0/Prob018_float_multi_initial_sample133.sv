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
reg [8:0] a_exponent, b_exponent, z_exponent; // Adjusted to 9 bits for correct representation
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize the counter and other signals on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        z_mantissa <= 24'b0;
        a_exponent <= 9'b0;
        b_exponent <= 9'b0;
        z_exponent <= 9'b0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
        product <= 50'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin // Input processing and extraction
                a_sign <= a[31];
                b_sign <= b[31];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                counter <= 3'b001;
            end
            3'b001: begin // Special cases handling and normalization
                // Handle NaN and infinity
                if ((a_exponent == 9'd255 && a_mantissa != 24'd0) || (b_exponent == 9'd255 && b_mantissa != 24'd0)) begin
                    // Result is NaN or infinity
                    z <= (a_exponent == 9'd255 && a_mantissa != 24'd0) ? a : b;
                end else if ((a_exponent == 9'd255 && a_mantissa == 24'd0) || (b_exponent == 9'd255 && b_mantissa == 24'd0)) begin
                    // Result is infinity
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 9'd255;
                    z_mantissa <= 24'd0;
                    z <= {z_sign, z_exponent, z_mantissa};
                end else begin
                    // Normalize mantissas
                    if (a_mantissa[23] == 1'b0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:0]};
                        a_exponent <= a_exponent - 9'd1;
                    end
                    if (b_mantissa[23] == 1'b0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:0]};
                        b_exponent <= b_exponent - 9'd1;
                    end
                    counter <= 3'b010;
                end
            end
            3'b010: begin // Multiplication and rounding
                // Multiply mantissas
                product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                // Combine signs
                z_sign <= a_sign ^ b_sign;
                // Adjust exponents
                z_exponent <= a_exponent + b_exponent - 9'd127;
                counter <= 3'b011;
            end
            3'b011: begin // Rounding and adjustment
                // Extract guard, round, and sticky bits
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                // Round the result
                if (round_bit && (guard_bit || sticky)) begin
                    z_mantissa <= product[47:24] + 1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                // Adjust for overflow or underflow
                if (z_exponent > 9'd255) begin
                    // Overflow
                    z_exponent <= 9'd255;
                    z_mantissa <= 24'd0;
                end else if (z_exponent < 9'd1) begin
                    // Underflow
                    z_exponent <= 9'd1;
                end
                counter <= 3'b100;
            end
            3'b100: begin // Output generation
                // Format the result in IEEE 754 standard
                z <= {z_sign, z_exponent, z_mantissa[23:0]};
                counter <= 3'b000;
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule