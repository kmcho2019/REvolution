module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [22:0] a_mantissa, b_mantissa;
reg [7:0] a_exponent, b_exponent;
reg sign_bit;
reg [47:0] product_mantissa;
reg [7:0] product_exponent;
reg [2:0] counter;

// Special case signals
reg a_nan, b_nan, a_inf, b_inf;
reg overflow, underflow;

always @(posedge clk) begin
    if (rst) begin
        // Reset all signals
        a_mantissa <= 0;
        b_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        sign_bit <= 0;
        product_mantissa <= 0;
        product_exponent <= 0;
        counter <= 0;
        z <= 0;
        a_nan <= 0;
        b_nan <= 0;
        a_inf <= 0;
        b_inf <= 0;
        overflow <= 0;
        underflow <= 0;
    end else begin
        case (counter)
            0: begin
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                sign_bit <= a[31] ^ b[31];

                // Check for special cases
                a_nan <= (a_exponent == 8'd255 && a_mantissa!= 0);
                b_nan <= (b_exponent == 8'd255 && b_mantissa!= 0);
                a_inf <= (a_exponent == 8'd255 && a_mantissa == 0);
                b_inf <= (b_exponent == 8'd255 && b_mantissa == 0);

                // Perform multiplication
                product_mantissa <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                product_exponent <= a_exponent + b_exponent - 8'd127;

                counter <= counter + 1;
            end
            1: begin
                // Handle special cases
                if (a_nan || b_nan) begin
                    // NaN result
                    z <= 32'h7fc00000;
                end else if (a_inf || b_inf) begin
                    // Infinity result
                    z <= sign_bit? 32'hff800000 : 32'h7f800000;
                end else begin
                    // Round and normalize result
                    // Round-to-nearest-even implementation
                    reg [1:0] guard_bit, round_bit;
                    guard_bit <= product_mantissa[1:0];
                    round_bit <= product_mantissa[0];
                    if (guard_bit == 2'b10 && round_bit == 1'b1) begin
                        // Round up
                        product_mantissa <= product_mantissa + 1;
                    end else if (guard_bit == 2'b11) begin
                        // Round up
                        product_mantissa <= product_mantissa + 1;
                    end

                    // Normalize result
                    if (product_exponent > 8'd255) begin
                        // Overflow
                        overflow <= 1;
                        z <= sign_bit? 32'hff7fffff : 32'h7f7fffff;
                    end else if (product_exponent < 8'd1) begin
                        // Underflow
                        underflow <= 1;
                        z <= 32'h00000000;
                    end else begin
                        // Normal result
                        z <= {sign_bit, product_exponent + 8'd127, product_mantissa[22:0]};
                    end
                end

                counter <= 0;
            end
        endcase
    end
end

endmodule