module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [23:0] a_mantissa, b_mantissa;
reg [7:0] a_exponent, b_exponent; // Adjusted exponent width
reg sign_bit;
reg [47:0] product_mantissa;
reg [7:0] product_exponent;
reg [2:0] state;

// State machine
always @(posedge clk) begin
    if (rst) begin
        state <= 0;
        z <= 0;
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
                // Special cases handling
                if ((a_exponent == 8'hff && a_mantissa != 0) || (b_exponent == 8'hff && b_mantissa != 0)) begin
                    // NaN
                    z <= 32'h7fc00000;
                end else if ((a_exponent == 8'hff && a_mantissa == 0) || (b_exponent == 8'hff && b_mantissa == 0)) begin
                    // Infinity
                    z <= {sign_bit, 8'hff, 23'h0};
                end else begin
                    // Proceed with multiplication
                    product_mantissa <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                    product_exponent <= a_exponent + b_exponent - 127; // Adjusted bias
                    state <= 2;
                end
            end
            2: begin
                // Rounding and normalization
                if (product_exponent > 255) begin
                    // Overflow
                    z <= {sign_bit, 8'hff, 23'h0};
                end else if (product_exponent < -126) begin
                    // Underflow
                    z <= 32'h00000000;
                end else begin
                    // Normalize and round
                    z <= {sign_bit, product_exponent + 127, product_mantissa[23:0]};
                end
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

endmodule