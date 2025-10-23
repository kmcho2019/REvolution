module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization and input processing
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Input extraction
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                counter <= 3'b001;
            end
            3'b001: begin // Special cases handling
                if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin // NaN or Infinity
                    if ((a_exponent == 9'b11111111) && (b_exponent == 9'b11111111)) begin
                        z_sign <= a_sign || b_sign;
                        z_exponent <= 9'b11111111;
                        z_mantissa <= 24'b0;
                        counter <= 3'b100; // Output generation
                    end else begin
                        z_sign <= a_sign || b_sign;
                        z_exponent <= 9'b11111111;
                        z_mantissa <= 24'b0;
                        counter <= 3'b100; // Output generation
                    end
                end else begin
                    counter <= 3'b010; // Normalization
                end
            end
            3'b010: begin // Normalization
                if (a_mantissa[23] == 1'b0) begin // Normalize a
                    a_mantissa <= {1'b1, a_mantissa[22:1]};
                    a_exponent <= a_exponent - 1'b1;
                end
                if (b_mantissa[23] == 1'b0) begin // Normalize b
                    b_mantissa <= {1'b1, b_mantissa[22:1]};
                    b_exponent <= b_exponent - 1'b1;
                end
                counter <= 3'b011; // Multiplication
            end
            3'b011: begin // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b100; // Rounding and adjustment
            end
            3'b100: begin // Rounding and adjustment
                z_mantissa <= product[49:26];
                guard_bit <= product[25];
                round_bit <= product[24];
                sticky <= product[23:0]!= 0;
                if ((guard_bit && (round_bit || sticky)) || (z_exponent == 255)) begin
                    z_mantissa <= z_mantissa + 1'b1;
                end
                if (z_exponent > 255) begin // Overflow
                    z_exponent <= 255;
                    z_mantissa <= 24'b0;
                end else if (z_exponent < 1) begin // Underflow
                    z_exponent <= 0;
                    z_mantissa <= 24'b0;
                end
                counter <= 3'b101; // Output generation
            end
            3'b101: begin // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule