module float_multi(clk, rst, a, b, z);
    input clk;
    input rst;
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] z;

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            case (counter)
                0: begin
                    // Extract mantissas, exponents, and sign bits
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];

                    // Check for special cases (NaN, infinity)
                    if (a_exponent == 8'hff && a_mantissa != 0) begin
                        // a is NaN
                        z <= a;
                    end else if (b_exponent == 8'hff && b_mantissa != 0) begin
                        // b is NaN
                        z <= b;
                    end else if (a_exponent == 8'hff && a_mantissa == 0) begin
                        // a is infinity
                        if (b_exponent == 8'hff && b_mantissa == 0) begin
                            // b is also infinity
                            z_sign <= a_sign ^ b_sign;
                            z_exponent <= 8'hff;
                            z_mantissa <= 0;
                        end else begin
                            // b is not infinity
                            z <= {a_sign, 8'hff, 23'h0};
                        end
                    end else if (b_exponent == 8'hff && b_mantissa == 0) begin
                        // b is infinity
                        z <= {a_sign, 8'hff, 23'h0};
                    end else begin
                        // Both are normal numbers
                        counter <= counter + 1;
                    end
                end
                1: begin
                    // Normalize mantissas if needed
                    if (a_mantissa[22] == 0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:1]};
                        a_exponent <= a_exponent - 1;
                    end
                    if (b_mantissa[22] == 0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:1]};
                        b_exponent <= b_exponent - 1;
                    end

                    // Multiply mantissas
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};

                    // Adjust exponent
                    z_exponent <= a_exponent + b_exponent - 127;

                    // Determine sign of result
                    z_sign <= a_sign ^ b_sign;

                    counter <= counter + 1;
                end
                2: begin
                    // Round result
                    guard_bit <= product[48];
                    round_bit <= product[47];
                    sticky <= |product[46:0];

                    if (guard_bit && (round_bit || sticky)) begin
                        z_mantissa <= product[46:23] + 1;
                    end else begin
                        z_mantissa <= product[46:23];
                    end

                    // Check for overflow and underflow
                    if (z_exponent > 8'hff) begin
                        // Overflow
                        z <= {z_sign, 8'hff, 23'h0};
                    end else if (z_exponent < 1) begin
                        // Underflow
                        z_exponent <= 1;
                        z_mantissa <= {z_mantissa[22:0], 23'h0};
                    end else begin
                        // Normal result
                        z <= {z_sign, z_exponent, z_mantissa};
                    end

                    counter <= 0;
                end
            endcase
        end
    end
endmodule