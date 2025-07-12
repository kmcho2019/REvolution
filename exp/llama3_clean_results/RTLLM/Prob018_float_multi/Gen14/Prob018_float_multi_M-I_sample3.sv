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
reg guard_bit, round_bit, sticky;

// Input Processing Unit (IPU)
always @(posedge clk) begin
    if (rst) begin
        a_mantissa <= 0;
        b_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        sign_bit <= 0;
    end else begin
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        sign_bit <= a[31] ^ b[31];
    end
end

// Mantissa Multiplier Array (MMA)
reg [47:0] mma_result;
always @(posedge clk) begin
    if (rst) begin
        mma_result <= 0;
    end else begin
        mma_result <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
    end
end

// Exponent Adder (EA)
always @(posedge clk) begin
    if (rst) begin
        product_exponent <= 0;
    end else begin
        product_exponent <= a_exponent + b_exponent - 127; // Adjust for bias
    end
end

// Centralized Control Unit (CCU)
always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
    end else if (counter == 0) begin
        // Perform multiplication
        product_mantissa <= mma_result;
        counter <= counter + 1;
    end else if (counter == 1) begin
        // Perform rounding and normalization
        z <= {sign_bit, product_exponent + 127, product_mantissa[22:0]}; // Adjust for bias
        counter <= 0;
    end
end

// Rounding and Normalization Unit (RNU)
always @(posedge clk) begin
    if (rst) begin
        // Reset RNU
        guard_bit <= 0;
        round_bit <= 0;
        sticky <= 0;
    end else if (counter == 1) begin
        // Perform rounding
        guard_bit <= product_mantissa[21];
        round_bit <= product_mantissa[20];
        sticky <= |product_mantissa[19:0];
        if (guard_bit && (round_bit || sticky)) begin
            product_mantissa <= product_mantissa + 1;
        end
        // Perform normalization
        if (product_mantissa[47]) begin
            product_mantissa <= product_mantissa >> 1;
            product_exponent <= product_exponent + 1;
        end
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