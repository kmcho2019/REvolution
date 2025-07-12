module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg [2:0] counter;

    // Combinational logic for input processing
    assign a_mantissa = a[22:0];
    assign a_exponent = a[30:23];
    assign a_sign = a[31];
    assign b_mantissa = b[22:0];
    assign b_exponent = b[30:23];
    assign b_sign = b[31];

    // Sequential logic for state machine
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
            counter <= 0;
        end else begin
            case (counter)
                0: begin
                    // Special cases handling
                    if ((a_exponent == 8'hff && a_mantissa != 0) || (b_exponent == 8'hff && b_mantissa != 0)) begin
                        z <= 32'h7fc00000; // NaN
                    end else if (a_exponent == 8'hff && a_mantissa == 0) begin
                        if (a_sign == b_sign) begin
                            z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                        end else begin
                            z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                        end
                    end else if (b_exponent == 8'hff && b_mantissa == 0) begin
                        if (a_sign == b_sign) begin
                            z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                        end else begin
                            z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                        end
                    end else begin
                        counter <= counter + 1;
                    end
                end
                1: begin
                    // Normalization and multiplication
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    z_exponent <= a_exponent + b_exponent - 127;
                    z_sign <= a_sign ^ b_sign;
                    counter <= counter + 1;
                end
                2: begin
                    // Rounding and adjustment
                    z_mantissa <= product[47:24];
                    if (product[23] && (product[22] || |product[21:0])) begin
                        z_mantissa <= z_mantissa + 1;
                        if (z_mantissa == 24'h1000000) begin
                            z_exponent <= z_exponent + 1;
                            z_mantissa <= 0;
                        end
                    end

                    // Output generation
                    if (z_exponent > 255) begin
                        z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                    end else if (z_exponent < 1) begin
                        z <= {1'b0, 8'h0, 23'd0}; // 0
                    end else begin
                        z <= {z_sign, z_exponent, z_mantissa};
                    end
                    counter <= 0;
                end
                default: begin
                    counter <= 0;
                end
            endcase
        end
    end
endmodule