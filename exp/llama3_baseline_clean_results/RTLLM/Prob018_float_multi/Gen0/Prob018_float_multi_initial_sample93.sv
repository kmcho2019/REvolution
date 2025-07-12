module float_multi(clk, rst, a, b, z);
    input        clk;
    input        rst;
    input  [31:0] a, b;
    output reg [31:0] z;

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0]  a_exponent, b_exponent, z_exponent;
    reg         a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg         guard_bit, round_bit, sticky;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'b0;
        end else begin
            case (counter)
                3'b000: begin // Initialization
                    a_mantissa <= {a[22], a[21:0]};
                    b_mantissa <= {b[22], b[21:0]};
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign     <= a[31];
                    b_sign     <= b[31];
                    counter    <= counter + 1'b1;
                end
                3'b001: begin // Special cases handling
                    if ((a_exponent == 8'bff && a_mantissa != 0) || (b_exponent == 8'bff && b_mantissa != 0)) begin
                        // NaN or infinity handling
                        if ((a_exponent == 8'bff && a_mantissa != 0) && (b_exponent == 8'bff && b_mantissa != 0)) begin
                            // Both NaN
                            z_sign <= 1'b0;
                            z_exponent <= 8'bff;
                            z_mantissa <= 24'b1;
                        end else if (a_exponent == 8'bff && a_mantissa != 0) begin
                            // a is NaN
                            z_sign <= a_sign;
                            z_exponent <= 8'bff;
                            z_mantissa <= a_mantissa;
                        end else begin
                            // b is NaN
                            z_sign <= b_sign;
                            z_exponent <= 8'bff;
                            z_mantissa <= b_mantissa;
                        end
                        counter <= 3'b111; // Done
                    end else if (a_exponent == 8'bff || b_exponent == 8'bff) begin
                        // Infinity handling
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 8'bff;
                        z_mantissa <= 24'b0;
                        counter <= 3'b111; // Done
                    end else begin
                        // Normal numbers, proceed with multiplication
                        counter <= counter + 1'b1;
                    end
                end
                3'b010: begin // Multiplication
                    product <= (a_mantissa * b_mantissa);
                    z_exponent <= a_exponent + b_exponent - 127;
                    counter    <= counter + 1'b1;
                end
                3'b011: begin // Rounding and adjustment
                    // Normalize the result
                    if (product[49]) begin
                        product <= product >> 1;
                        z_exponent <= z_exponent + 1'b1;
                    end
                    // Extract the guard, round, and sticky bits
                    guard_bit  <= product[23];
                    round_bit  <= product[22];
                    sticky     <= |product[21:0];
                    // Round the result
                    if (guard_bit && (round_bit || sticky)) begin
                        z_mantissa <= product[49:26] + 1'b1;
                    end else begin
                        z_mantissa <= product[49:26];
                    end
                    z_sign     <= a_sign ^ b_sign;
                    counter    <= counter + 1'b1;
                end
                3'b100: begin // Output generation
                    z <= {z_sign, z_exponent, z_mantissa[23:0]};
                    counter <= 3'b111; // Done
                end
                default: ; // Do nothing
            endcase
        end
    end
endmodule