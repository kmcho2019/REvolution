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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Input Processing: Extract mantissas, exponents, and sign bits
                a_mantissa <= {1'b1, a[22:0]};
                b_mantissa <= {1'b1, b[22:0]};
                a_exponent <= a[30:23] - 127;
                b_exponent <= b[30:23] - 127;
                a_sign <= a[31];
                b_sign <= b[31];

                // Special Cases Handling: NaN and infinity
                if ((a[30:23] == 9'b255) && (a[22:0] != 23'b0)) begin
                    // NaN handling
                    z <= a;
                end else if ((b[30:23] == 9'b255) && (b[22:0] != 23'b0)) begin
                    // NaN handling
                    z <= b;
                end else if ((a[30:23] == 9'b255) && (a[22:0] == 23'b0)) begin
                    // Infinity handling
                    if (b[30:23] == 9'b255) begin
                        // Infinity * Infinity
                        z <= {a_sign ^ b_sign, 8'b11111111, 23'b0};
                    end else begin
                        // Infinity * finite number
                        z <= {a_sign, 8'b11111111, 23'b0};
                    end
                end else if ((b[30:23] == 9'b255) && (b[22:0] == 23'b0)) begin
                    // Finite number * Infinity
                    z <= {a_sign ^ b_sign, 8'b11111111, 23'b0};
                end else begin
                    // Normal case
                    counter <= counter + 1;
                end
            end
            3'b001: begin
                // Normalization: Normalize mantissas if needed
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= {a_mantissa[22:0], 1'b0} << 1;
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= {b_mantissa[22:0], 1'b0} << 1;
                    b_exponent <= b_exponent - 1;
                end

                // Multiplication: Multiply mantissas and adjust exponents
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent + 1;
                z_sign <= a_sign ^ b_sign;

                counter <= counter + 1;
            end
            3'b010: begin
                // Rounding and Adjustment: Round the result and adjust the exponent
                z_mantissa <= product[49:26];
                guard_bit <= product[25];
                round_bit <= product[24];
                sticky <= product[23:0] != 0;

                if ((guard_bit || round_bit || sticky) && (z_mantissa[23] == 1'b1)) begin
                    z_mantissa <= z_mantissa + 1;
                    if (z_mantissa[23] == 1'b0) begin
                        z_exponent <= z_exponent + 1;
                    end
                end

                counter <= counter + 1;
            end
            3'b011: begin
                // Output Generation: Format the final result in IEEE 754 standard
                if (z_exponent > 255) begin
                    // Overflow
                    z <= {z_sign, 8'b11111111, 23'b0};
                end else if (z_exponent < -126) begin
                    // Underflow
                    z <= {z_sign, 8'b0, 23'b0};
                end else begin
                    z <= {z_sign, z_exponent + 127, z_mantissa[22:0]};
                end

                counter <= 3'b000;
            end
            default: begin
                counter <= counter + 1;
            end
        endcase
    end
end

endmodule