module float_multi(clk, rst, a, b, z);
    input           clk;
    input           rst;
    input  [31:0]   a;
    input  [31:0]   b;
    output reg [31:0] z;

    reg [2:0]       counter;
    reg [23:0]      a_mantissa, b_mantissa, z_mantissa;
    reg [7:0]       a_exponent, b_exponent, z_exponent;
    reg             a_sign, b_sign, z_sign;
    reg [49:0]      product;
    reg             guard_bit, round_bit, sticky;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            a_mantissa <= 24'b0;
            b_mantissa <= 24'b0;
            z_mantissa <= 24'b0;
            a_exponent <= 8'b0;
            b_exponent <= 8'b0;
            z_exponent <= 8'b0;
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;
            product <= 50'b0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;
        end else begin
            case (counter)
                3'b000: begin // Input processing
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];
                    z_exponent <= a_exponent + b_exponent;
                    z_sign <= a_sign ^ b_sign;
                    counter <= 3'b001;
                end
                3'b001: begin // Special cases handling
                    if ((a_exponent == 8'b11111111 && a_mantissa != 0) || (b_exponent == 8'b11111111 && b_mantissa != 0)) begin // NaN
                        z <= 32'b0;
                    end else if ((a_exponent == 8'b11111111 && a_mantissa == 0) || (b_exponent == 8'b11111111 && b_mantissa == 0)) begin // Infinity
                        z <= 32'b0;
                    end else begin
                        counter <= 3'b010;
                    end
                end
                3'b010: begin // Normalization
                    if (a_exponent != 0) begin
                        a_mantissa <= {1'b1, a_mantissa};
                    end
                    if (b_exponent != 0) begin
                        b_mantissa <= {1'b1, b_mantissa};
                    end
                    counter <= 3'b011;
                end
                3'b011: begin // Multiplication
                    product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                    counter <= 3'b100;
                end
                3'b100: begin // Rounding and adjustment
                    if (product[49]) begin // overflow
                        product <= product >> 1;
                        z_exponent <= z_exponent + 1'b1;
                    end else if (product[48] && (product[47:0] != 0)) begin // round up
                        product <= product + 1;
                        if (product[49]) begin // overflow
                            product <= product >> 1;
                            z_exponent <= z_exponent + 1'b1;
                        end
                    end
                    counter <= 3'b101;
                end
                3'b101: begin // Output generation
                    z_mantissa <= product[47:24];
                    z_exponent <= z_exponent - 8'b01111111;
                    if (z_exponent > 8'b11111110) begin // overflow
                        z <= {1'b1, 8'b11111111, 23'b0};
                    end else if (z_exponent < 8'b01111111) begin // underflow
                        z <= {z_sign, z_exponent, z_mantissa};
                    end else begin
                        z <= {z_sign, z_exponent, z_mantissa};
                    end
                    counter <= 3'b000;
                end
            endcase
        end
    end
endmodule