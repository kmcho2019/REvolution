module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [9:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'd0;
        a_mantissa <= 24'd0;
        b_mantissa <= 24'd0;
        z_mantissa <= 24'd0;
        a_exponent <= 10'd0;
        b_exponent <= 10'd0;
        z_exponent <= 10'd0;
        a_sign <= 1'd0;
        b_sign <= 1'd0;
        z_sign <= 1'd0;
        product <= 50'd0;
        guard_bit <= 1'd0;
        round_bit <= 1'd0;
        sticky <= 1'd0;
    end else begin
        case (counter)
            3'd0: begin // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            3'd1: begin // Special cases handling
                if (a_exponent == 10'd255 || b_exponent == 10'd255) begin // NaN or infinity
                    if (a_exponent == 10'd255) begin
                        z_exponent <= 10'd255;
                        z_mantissa <= a_mantissa;
                        z_sign <= a_sign;
                    end else begin
                        z_exponent <= 10'd255;
                        z_mantissa <= b_mantissa;
                        z_sign <= b_sign;
                    end
                    counter <= 3'd6;
                end else begin
                    counter <= counter + 1;
                end
            end
            3'd2: begin // Normalization
                if (a_exponent != 10'd0) begin
                    a_mantissa <= {1'd1, a_mantissa};
                end
                if (b_exponent != 10'd0) begin
                    b_mantissa <= {1'd1, b_mantissa};
                end
                counter <= counter + 1;
            end
            3'd3: begin // Multiplication
                product <= {1'd1, a_mantissa} * {1'd1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 10'd127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3'd4: begin // Rounding and adjustment
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[49:3];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[23:0] + 24'd1;
                    if (z_mantissa == 24'd0) begin
                        z_exponent <= z_exponent + 1;
                    end
                end else begin
                    z_mantissa <= product[23:0];
                end
                counter <= counter + 1;
            end
            3'd5: begin // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'd0;
            end
            3'd6: begin // Overflow/underflow handling
                if (z_exponent > 10'd255) begin // Overflow
                    z_exponent <= 10'd255;
                    z_mantissa <= 24'd0;
                end else if (z_exponent < 10'd1) begin // Underflow
                    z_exponent <= 10'd0;
                    z_mantissa <= 24'd0;
                end
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'd0;
            end
            default: counter <= counter;
        endcase
    end
end

endmodule