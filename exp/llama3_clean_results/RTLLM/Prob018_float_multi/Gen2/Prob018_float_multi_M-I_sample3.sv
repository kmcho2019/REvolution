module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg [2:0] counter;

    // State Machine
    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state <= 2'b00;
            z <= 0;
        end else begin
            case (state)
                2'b00: begin // Input Processing
                    if (a[31] == 1'b1) a_sign <= 1'b1;
                    else a_sign <= 1'b0;
                    if (b[31] == 1'b1) b_sign <= 1'b1;
                    else b_sign <= 1'b0;

                    a_mantissa <= a[22:0];
                    a_exponent <= a[30:23];
                    b_mantissa <= b[22:0];
                    b_exponent <= b[30:23];

                    state <= 2'b01;
                end
                2'b01: begin // Special Cases Handling
                    if ((a_exponent == 8'hff && a_mantissa!= 0) || (b_exponent == 8'hff && b_mantissa!= 0)) begin
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
                        state <= 2'b10;
                    end
                end
                2'b10: begin // Multiplication
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    z_exponent <= a_exponent + b_exponent - 127;
                    z_sign <= a_sign ^ b_sign;
                    state <= 2'b11;
                end
                2'b11: begin // Rounding and Adjustment
                    z_mantissa <= product[47:24];
                    if (product[23] && (product[22] || |product[21:0])) begin
                        z_mantissa <= z_mantissa + 1;
                        if (z_mantissa == 24'h1000000) begin
                            z_exponent <= z_exponent + 1;
                            z_mantissa <= 0;
                        end
                    end

                    // Output Generation
                    if (z_exponent > 255) begin
                        z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                    end else if (z_exponent < 1) begin
                        z <= {1'b0, 8'h0, 23'd0}; // 0
                    end else begin
                        z <= {z_sign, z_exponent, z_mantissa};
                    end
                    state <= 2'b00;
                end
                default: begin
                    state <= 2'b00;
                end
            endcase
        end
    end
endmodule