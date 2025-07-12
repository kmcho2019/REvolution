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

// Initialization
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Input Processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                counter <= 3'b001;
            end
            3'b001: begin
                // Special Cases Handling
                if (a_exponent == 9'b11111111 || b_exponent == 9'b11111111) begin
                    // Handle NaN and infinity
                    if (a_exponent == 9'b11111111 && a_mantissa != 23'b0) begin
                        z <= {a_sign, 8'b11111111, 23'b0}; // NaN
                    end else if (b_exponent == 9'b11111111 && b_mantissa != 23'b0) begin
                        z <= {b_sign, 8'b11111111, 23'b0}; // NaN
                    end else if (a_exponent == 9'b11111111 && a_mantissa == 23'b0) begin
                        z <= {a_sign, 8'b11111111, 23'b0}; // Infinity
                    end else if (b_exponent == 9'b11111111 && b_mantissa == 23'b0) begin
                        z <= {b_sign, 8'b11111111, 23'b0}; // Infinity
                    end
                    counter <= 3'b000;
                end else begin
                    counter <= 3'b010;
                end
            end
            3'b010: begin
                // Normalization
                if (a_exponent != 0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                end
                if (b_exponent != 0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                end
                counter <= 3'b011;
            end
            3'b011: begin
                // Multiplication
                product <= {a_mantissa, 23'b0} * {b_mantissa, 23'b0};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b100;
            end
            3'b100: begin
                // Rounding and Adjustment
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[46:23] + 1;
                end else begin
                    z_mantissa <= product[46:23];
                end
                if (z_exponent > 254) begin
                    z <= {z_sign, 8'b11111111, 23'b0}; // Overflow
                end else if (z_exponent < -126) begin
                    z <= {z_sign, 8'b0, 23'b0}; // Underflow
                end else begin
                    z <= {z_sign, z_exponent[7:0], z_mantissa};
                end
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule