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

    // Initialization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'b0;
        end
        else begin
            case (counter)
                3'b000: begin
                    // Input processing
                    a_mantissa <= a[22:0];
                    a_exponent <= a[30:23];
                    a_sign <= a[31];
                    b_mantissa <= b[22:0];
                    b_exponent <= b[30:23];
                    b_sign <= b[31];
                    counter <= counter + 1;
                end
                3'b001: begin
                    // Special cases handling
                    if ((a_exponent == 9'b11111111 && a_mantissa != 0) || (b_exponent == 9'b11111111 && b_mantissa != 0)) begin
                        // NaN or infinity
                        z <= (a_exponent == 9'b11111111) ? a : b;
                        counter <= 3'b000;
                    end
                    else if ((a_exponent == 9'b0 && a_mantissa == 0) || (b_exponent == 9'b0 && b_mantissa == 0)) begin
                        // Zero
                        z <= 32'b0;
                        counter <= 3'b000;
                    end
                    else begin
                        counter <= counter + 1;
                    end
                end
                3'b010: begin
                    // Normalization
                    if (a_mantissa[23] == 1'b0) begin
                        // Normalize a
                        a_mantissa <= {1'b1, a_mantissa[22:1]};
                        a_exponent <= a_exponent - 1;
                    end
                    if (b_mantissa[23] == 1'b0) begin
                        // Normalize b
                        b_mantissa <= {1'b1, b_mantissa[22:1]};
                        b_exponent <= b_exponent - 1;
                    end
                    counter <= counter + 1;
                end
                3'b011: begin
                    // Multiplication
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= a_exponent + b_exponent;
                    z_sign <= a_sign ^ b_sign;
                    counter <= counter + 1;
                end
                3'b100: begin
                    // Rounding and adjustment
                    guard_bit <= product[49];
                    round_bit <= product[48];
                    sticky <= |product[47:0];
                    if (guard_bit && (round_bit || sticky)) begin
                        // Round up
                        z_mantissa <= product[48:25] + 1;
                    end
                    else begin
                        // Round down
                        z_mantissa <= product[48:25];
                    end
                    if (z_mantissa[23] == 1'b1) begin
                        // Overflow
                        z_exponent <= z_exponent + 1;
                        z_mantissa <= z_mantissa >> 1;
                    end
                    counter <= counter + 1;
                end
                3'b101: begin
                    // Output generation
                    z <= {z_sign, z_exponent[8:0], z_mantissa};
                    counter <= 3'b000;
                end
            endcase
        end
    end
endmodule