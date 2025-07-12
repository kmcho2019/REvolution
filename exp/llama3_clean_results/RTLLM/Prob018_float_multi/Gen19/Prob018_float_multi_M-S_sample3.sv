module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] state;
reg [31:0] a_mantissa_exponent, b_mantissa_exponent;
reg [22:0] product_mantissa;
reg [7:0] product_exponent;
reg product_sign;

// State machine
always @(posedge clk) begin
    if (rst) begin
        state <= 3'b000;
    end else begin
        case (state)
            3'b000: begin // Input processing
                a_mantissa_exponent[31] <= a[31]; // Sign bit
                a_mantissa_exponent[30:23] <= a[30:23]; // Exponent
                a_mantissa_exponent[22:0] <= a[22:0]; // Mantissa
                b_mantissa_exponent[31] <= b[31]; // Sign bit
                b_mantissa_exponent[30:23] <= b[30:23]; // Exponent
                b_mantissa_exponent[22:0] <= b[22:0]; // Mantissa
                state <= 3'b001;
            end
            3'b001: begin // Exponent calculation and mantissa multiplication
                product_exponent <= a_mantissa_exponent[30:23] + b_mantissa_exponent[30:23] - 8'd127;
                product_mantissa <= a_mantissa_exponent[22:0] * b_mantissa_exponent[22:0];
                product_sign <= a_mantissa_exponent[31] ^ b_mantissa_exponent[31];
                state <= 3'b010;
            end
            3'b010: begin // Normalization and rounding
                if (product_mantissa[22] == 1'b1) begin
                    product_exponent <= product_exponent + 1;
                    product_mantissa <= product_mantissa >> 1;
                end
                z <= {product_sign, product_exponent, product_mantissa};
                state <= 3'b000;
            end
            default: state <= 3'b000;
        endcase
    end
end

// Special case handling for NaN and infinity
always @(*) begin
    if ((a_mantissa_exponent[30:23] == 8'd255 && a_mantissa_exponent[22:0] != 23'd0) || (b_mantissa_exponent[30:23] == 8'd255 && b_mantissa_exponent[22:0] != 23'd0)) begin
        z <= 32'd0; // Set output to zero
    end
end

endmodule