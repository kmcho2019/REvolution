module float_multi(clk, rst, a, b, z);
    input clk;
    input rst;
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] z;

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
                    // Extract mantissas, exponents, and sign bits
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];
                    counter <= counter + 1'b1;
                end
                3'b001: begin
                    // Handle special cases (NaN, infinity)
                    if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                        // Handle NaN or infinity
                        if ((a_exponent == 9'b11111111) && (a_mantissa!= 24'b0)) begin
                            z <= {a[31], 8'b11111111, 23'b0}; // NaN
                        end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 24'b0)) begin
                            z <= {b[31], 8'b11111111, 23'b0}; // NaN
                        end else if (a_exponent == 9'b11111111) begin
                            z <= {a[31], 8'b11111111, 23'b0}; // Infinity
                        end else begin
                            z <= {b[31], 8'b11111111, 23'b0}; // Infinity
                        end
                    end else begin
                        // Normalize mantissas if needed
                        if (a_mantissa[23] == 1'b0) begin
                            a_mantissa <= {1'b1, a_mantissa[22:0]};
                            a_exponent <= a_exponent - 1'b1;
                        end
                        if (b_mantissa[23] == 1'b0) begin
                            b_mantissa <= {1'b1, b_mantissa[22:0]};
                            b_exponent <= b_exponent - 1'b1;
                        end
                        counter <= counter + 1'b1;
                    end
                end
                3'b010: begin
                    // Multiply mantissas
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= a_exponent + b_exponent + 1'b1;
                    z_sign <= a_sign ^ b_sign;
                    counter <= counter + 1'b1;
                end
                3'b011: begin
                    // Round and adjust
                    guard_bit <= product[0];
                    round_bit <= product[1];
                    sticky <= |product[49:2];
                    if ((guard_bit == 1'b1) && (round_bit == 1'b1 || sticky == 1'b1)) begin
                        z_mantissa <= product[48:25] + 1'b1;
                    end else begin
                        z_mantissa <= product[48:25];
                    end
                    if (z_mantissa[23] == 1'b1) begin
                        z_exponent <= z_exponent + 1'b1;
                        z_mantissa <= z_mantissa >> 1;
                    end
                    counter <= counter + 1'b1;
                end
                3'b100: begin
                    // Output generation
                    if (z_exponent == 10'b1111111111) begin
                        // Overflow
                        z <= {z_sign, 8'b11111111, 23'b0};
                    end else if (z_exponent == 10'b0) begin
                        // Underflow
                        z <= {z_sign, 8'b0, z_mantissa};
                    end else begin
                        z <= {z_sign, z_exponent[8:0], z_mantissa};
                    end
                    counter <= 3'b000;
                end
            endcase
        end
    end
endmodule