module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [23:0] a_mantissa, b_mantissa;
reg [8:0] a_exponent, b_exponent;
reg sign_bit;
reg [47:0] product_mantissa;
reg [8:0] product_exponent;
reg [2:0] state;

// Extract inputs
assign a_mantissa = a[22:0];
assign b_mantissa = b[22:0];
assign a_exponent = a[30:23];
assign b_exponent = b[30:23];
assign sign_bit = a[31] ^ b[31];

// State machine
always @(posedge clk) begin
    if (rst) begin
        state <= 0;
        product_exponent <= 0;
        product_mantissa <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // Input processing and multiplication
                product_exponent <= a_exponent + b_exponent - 127; // Bias adjustment
                product_mantissa <= {1'b1, a_mantissa} * {1'b1, b_mantissa}; // Multiply with implicit leading 1
                state <= 1;
            end
            1: begin // Normalization and rounding
                if (product_mantissa[47]) begin // Overflow
                    product_mantissa <= product_mantissa >> 1;
                    product_exponent <= product_exponent + 1;
                end
                // Rounding logic can be added here based on the rounding mode (e.g., round to nearest even)
                state <= 2;
            end
            2: begin // Output generation
                z <= {sign_bit, product_exponent + 127, product_mantissa[23:0]}; // Add bias back
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
end

// Special cases handling
always @(posedge clk) begin
    if (rst) begin
        // Reset special cases
    end else if (a_exponent == 255 && a_mantissa != 0) begin
        // NaN
        z <= 32'h7fc00000;
    end else if (b_exponent == 255 && b_mantissa != 0) begin
        // NaN
        z <= 32'h7fc00000;
    end else if (a_exponent == 255 && a_mantissa == 0) begin
        // Infinity
        z <= sign_bit? 32'hff800000 : 32'h7f800000;
    end else if (b_exponent == 255 && b_mantissa == 0) begin
        // Infinity
        z <= sign_bit? 32'hff800000 : 32'h7f800000;
    end else if (product_exponent > 255) begin
        // Overflow
        z <= sign_bit? 32'hff7fffff : 32'h7f7fffff;
    end else if (product_exponent < 1) begin
        // Underflow
        z <= 32'h00000000;
    end
end

endmodule