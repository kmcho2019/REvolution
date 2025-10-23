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
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            a_exponent <= 9'd0;
            b_exponent <= 9'd0;
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;
            product <= 50'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;
            z <= 32'd0;
        end else begin
            case (counter)
                3'b000: begin // Input processing
                    if (a[31]) a_sign <= 1'b1; else a_sign <= 1'b0;
                    if (b[31]) b_sign <= 1'b1; else b_sign <= 1'b0;
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    counter <= counter + 1;
                end
                3'b001: begin // Special cases handling
                    if ((a_exponent == 9'd255 && a_mantissa!= 24'd0) || (b_exponent == 9'd255 && b_mantissa!= 24'd0)) begin
                        // NaN or infinity, handle accordingly
                        z <= 32'd0; // Example handling, actual handling may vary
                        counter <= 3'b000;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                3'b010: begin // Normalization
                    if (a_mantissa[23] == 1'b0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:0]};
                        a_exponent <= a_exponent - 1;
                    end
                    if (b_mantissa[23] == 1'b0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:0]};
                        b_exponent <= b_exponent - 1;
                    end
                    counter <= counter + 1;
                end
                3'b011: begin // Multiplication
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    z_exponent <= a_exponent + b_exponent - 127;
                    z_sign <= a_sign ^ b_sign;
                    counter <= counter + 1;
                end
                3'b100: begin // Rounding and adjustment
                    if (product[49:48] == 2'b10) begin
                        guard_bit <= 1'b1;
                    end else if (product[49:48] == 2'b01) begin
                        round_bit <= 1'b1;
                    end else if (product[49:48] == 2'b00) begin
                        sticky <= 1'b1;
                    end
                    z_mantissa <= product[47:24];
                    if (guard_bit || round_bit || sticky) begin
                        z_mantissa <= z_mantissa + 1;
                    end
                    counter <= counter + 1;
                end
                3'b101: begin // Output generation
                    z <= {z_sign, z_exponent, z_mantissa};
                    counter <= 3'b000;
                end
                default: begin
                    counter <= 3'b000;
                end
            endcase
        end
    end
endmodule