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

// State machine
always @(posedge clk) begin
    if (rst) begin
        state <= 0;
    end else begin
        case (state)
            0: begin
                // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                sign_bit <= a[31] ^ b[31];
                state <= 1;
            end
            1: begin
                // Mantissa multiplication
                product_mantissa <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                state <= 2;
            end
            2: begin
                // Exponent addition
                product_exponent <= a_exponent + b_exponent;
                state <= 3;
            end
            3: begin
                // Rounding and normalization
                z <= {sign_bit, product_exponent, product_mantissa[23:0]};
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

// Special cases handling
always @(posedge clk) begin
    if (rst) begin
        // Reset special cases
    end else if (a_exponent == 255 && a_mantissa!= 0) begin
        // NaN
        z <= 32'h7fc00000;
    end else if (b_exponent == 255 && b_mantissa!= 0) begin
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

// Rounding and normalization
assign product_mantissa = {1'b0, a_mantissa} * {1'b0, b_mantissa};

endmodule