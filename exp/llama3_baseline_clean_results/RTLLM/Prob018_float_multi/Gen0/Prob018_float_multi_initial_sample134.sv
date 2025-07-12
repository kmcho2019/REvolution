module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [7:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Initialization
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        if (counter == 3'b000) begin
            // Extract mantissas, exponents, and sign bits from inputs
            a_mantissa <= a[22:0];
            b_mantissa <= b[22:0];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_sign <= a[31];
            b_sign <= b[31];

            // Special cases handling: NaN and infinity
            if ((a_exponent == 8'b11111111 && a_mantissa != 23'b0) ||
                (b_exponent == 8'b11111111 && b_mantissa != 23'b0)) begin
                // Handle NaN
                z <= 32'b0; // Default result for NaN operations
                counter <= 3'b111; // Terminate operation
            end else if ((a_exponent == 8'b11111111 && a_mantissa == 23'b0) ||
                         (b_exponent == 8'b11111111 && b_mantissa == 23'b0)) begin
                // Handle infinity
                z_exponent <= 8'b11111111;
                z_mantissa <= 23'b0;
                if (a_sign ^ b_sign) begin
                    z_sign <= 1'b1;
                end else begin
                    z_sign <= 1'b0;
                end
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b111; // Terminate operation
            end else begin
                counter <= 3'b001;
            end
        end else if (counter == 3'b001) begin
            // Normalization
            if (a_exponent != 8'b0 && a_mantissa[23] == 1'b0) begin
                a_mantissa <= {1'b1, a_mantissa[22:0]};
                a_exponent <= a_exponent - 8'b1;
            end
            if (b_exponent != 8'b0 && b_mantissa[23] == 1'b0) begin
                b_mantissa <= {1'b1, b_mantissa[22:0]};
                b_exponent <= b_exponent - 8'b1;
            end

            // Multiplication
            product <= a_mantissa * b_mantissa;
            z_sign <= a_sign ^ b_sign;
            z_exponent <= a_exponent + b_exponent - 8'b127;

            counter <= 3'b010;
        end else if (counter == 3'b010) begin
            // Rounding and adjustment
            guard_bit <= product[49];
            round_bit <= product[48];
            sticky <= |product[47:0];

            if ((guard_bit && (round_bit || sticky)) || (round_bit && sticky)) begin
                z_mantissa <= product[47:24] + 1'b1;
                if (z_mantissa[23] == 1'b1) begin
                    z_exponent <= z_exponent + 1'b1;
                    z_mantissa <= {1'b1, z_mantissa[22:0]};
                end
            end else begin
                z_mantissa <= product[47:24];
            end

            counter <= 3'b011;
        end else if (counter == 3'b011) begin
            // Output generation
            if (z_exponent == 8'b0) begin
                // Underflow handling
                z_mantissa <= {1'b0, z_mantissa[22:0]};
                z_exponent <= 8'b1;
            end else if (z_exponent == 8'b255) begin
                // Overflow handling
                z_exponent <= 8'b11111111;
                z_mantissa <= 23'b0;
            end
            z <= {z_sign, z_exponent, z_mantissa};
            counter <= 3'b111; // Terminate operation
        end
    end
end

endmodule