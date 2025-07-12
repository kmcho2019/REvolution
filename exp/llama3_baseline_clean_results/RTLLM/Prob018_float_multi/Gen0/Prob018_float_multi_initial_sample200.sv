module float_multi(
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin
                // Extract mantissa, exponent, and sign bit from inputs
                a_mantissa <= {a[22], a[21:0]} + 1'b1; // implicit leading 1
                b_mantissa <= {b[22], b[21:0]} + 1'b1; // implicit leading 1
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];

                // Check for special cases (NaN, infinity)
                if ((a_exponent == 8'hff) && (a_mantissa!= 0)) begin
                    // a is NaN
                    z <= a;
                end else if ((b_exponent == 8'hff) && (b_mantissa!= 0)) begin
                    // b is NaN
                    z <= b;
                end else if ((a_exponent == 8'hff) && (a_mantissa == 0)) begin
                    // a is infinity
                    if ((b_exponent == 8'hff) && (b_mantissa == 0)) begin
                        // b is also infinity, result is infinity
                        z <= {a_sign, 8'hff, 23'b0};
                    end else begin
                        // result is infinity
                        z <= {a_sign, 8'hff, 23'b0};
                    end
                end else if ((b_exponent == 8'hff) && (b_mantissa == 0)) begin
                    // b is infinity, result is infinity
                    z <= {b_sign, 8'hff, 23'b0};
                end else begin
                    // Normal operation
                    counter <= counter + 1;
                end
            end

            1: begin
                // Normalize mantissas if needed
                if (a_mantissa[23] == 0) begin
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 0) begin
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= b_exponent - 1;
                end

                // Multiply mantissas and adjust exponents
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 127; // unbiased exponent
                z_sign <= a_sign ^ b_sign;

                counter <= counter + 1;
            end

            2: begin
                // Round and adjust result
                guard_bit <= product[1];
                round_bit <= product[0];
                sticky <= |product[49:2];

                if ((guard_bit == 1) && (round_bit == 1 || sticky == 1)) begin
                    z_mantissa <= product[49:26] + 1;
                    if (z_mantissa[23] == 1) begin
                        z_mantissa <= z_mantissa >> 1;
                        z_exponent <= z_exponent + 1;
                    end
                end else begin
                    z_mantissa <= product[49:26];
                end

                counter <= counter + 1;
            end

            3: begin
                // Format result in IEEE-754 standard
                z <= {z_sign, z_exponent + 127, z_mantissa[22:0]};
                counter <= 0;
            end

            default: begin
                counter <= 0;
            end
        endcase
    end
end

endmodule