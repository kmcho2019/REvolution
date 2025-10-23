module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

reg [2:0] state;
reg a_sign, b_sign;
reg [7:0] a_exponent, b_exponent;
reg [22:0] a_mantissa, b_mantissa;
reg [49:0] product_mantissa;
reg [8:0] product_exponent;
reg product_sign;

assign a_sign = a[31];
assign a_exponent = a[30:23];
assign a_mantissa = a[22:0];
assign b_sign = b[31];
assign b_exponent = b[30:23];
assign b_mantissa = b[22:0];

always @(posedge clk) begin
    if (rst) begin
        state <= 3'b000;
        z <= 0;
    end else begin
        case (state)
            3'b000: begin // Input processing and special case handling
                if (a_exponent == 8'd255 || b_exponent == 8'd255) begin
                    if ((a_exponent == 8'd255 && a_mantissa != 0) || (b_exponent == 8'd255 && b_mantissa != 0)) begin
                        z <= {1'b1, 8'd255, 23'd0}; // NaN
                    end else begin
                        z <= {(a_sign || b_sign), 8'd255, 23'd0}; // Infinity
                    end
                    state <= 3'b100; // Done
                end else begin
                    product_exponent <= a_exponent + b_exponent - 8'd127;
                    product_mantissa <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    product_sign <= a_sign ^ b_sign;
                    state <= 3'b001; // Normalization
                end
            end
            3'b001: begin // Normalization
                if (product_mantissa[49]) begin
                    product_exponent <= product_exponent + 1;
                    product_mantissa <= product_mantissa >> 1;
                end
                state <= 3'b010; // Rounding
            end
            3'b010: begin // Rounding
                if (product_mantissa[25]) begin
                    product_mantissa <= product_mantissa + 1;
                    if (product_mantissa[26]) begin
                        product_exponent <= product_exponent + 1;
                        product_mantissa <= product_mantissa >> 1;
                    end
                end
                z <= {product_sign, product_exponent, product_mantissa[25:2]};
                state <= 3'b100; // Done
            end
            3'b100: begin // Done
                // Stay in this state until reset
            end
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end

endmodule