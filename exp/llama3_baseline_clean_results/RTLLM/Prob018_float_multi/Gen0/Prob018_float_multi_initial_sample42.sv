module float_multi(clk, rst, a, b, z);
    input clk;
    input rst;
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] z;

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
        end else begin
            case (counter)
                3'b000: begin
                    // Input processing
                    a_mantissa <= {1'b1, a[22:0]};
                    b_mantissa <= {1'b1, b[22:0]};
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];
                    z_sign <= a_sign ^ b_sign;

                    // Special cases handling
                    if (a_exponent == 10'b1111111111 || b_exponent == 10'b1111111111) begin
                        // NaN or infinity
                        z <= (a_exponent == 10'b1111111111) ? a : b;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                3'b001: begin
                    // Normalization
                    if (a_exponent != 0) begin
                        a_mantissa <= a_mantissa << a_exponent;
                    end
                    if (b_exponent != 0) begin
                        b_mantissa <= b_mantissa << b_exponent;
                    end

                    // Multiplication
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= a_exponent + b_exponent - 10'b0111111111;
                    counter <= counter + 1;
                end
                3'b010: begin
                    // Rounding and adjustment
                    guard_bit <= product[1];
                    round_bit <= product[2];
                    sticky <= |product[49:3];
                    if (guard_bit && (round_bit || sticky)) begin
                        z_mantissa <= product[49:26] + 1;
                    end else begin
                        z_mantissa <= product[49:26];
                    end

                    // Exponent adjustment
                    if (z_mantissa[23]) begin
                        z_exponent <= z_exponent + 1;
                        z_mantissa <= z_mantissa >> 1;
                    end
                    counter <= counter + 1;
                end
                3'b011: begin
                    // Output generation
                    z <= {z_sign, z_exponent, z_mantissa[22:0]};
                    counter <= 3'b000;
                end
            endcase
        end
    end
endmodule