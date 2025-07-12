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
reg [2:0] state;
reg guard_bit, round_bit, sticky;

// Extract mantissas, exponents, and sign bits
always @(posedge clk) begin
    if (rst) begin
        a_mantissa <= 0;
        b_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        sign_bit <= 0;
    end else if (state == 0) begin
        // Input Processing
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        sign_bit <= a[31] ^ b[31];
    end
end

// Special cases handling
always @(posedge clk) begin
    if (rst) begin
        z <= 0;
    end else if (state == 0) begin
        // Check for special cases
        if ((a_exponent == 8'd255 && a_mantissa!= 0) || (b_exponent == 8'd255 && b_mantissa!= 0)) begin
            // NaN
            z <= 32'h7fc00000;
        end else if ((a_exponent == 8'd255 && a_mantissa == 0) || (b_exponent == 8'd255 && b_mantissa == 0)) begin
            // Infinity
            z <= sign_bit? 32'hff800000 : 32'h7f800000;
        end else begin
            state <= state + 1;
        end
    end
end

// Multiply mantissas and adjust exponents
always @(posedge clk) begin
    if (rst) begin
        product_mantissa <= 0;
        product_exponent <= 0;
    end else if (state == 1) begin
        // Normalize mantissas if needed
        if (a_mantissa[22] == 0) begin
            a_mantissa <= {1'b1, a_mantissa[21:0]};
            a_exponent <= a_exponent - 1;
        end
        if (b_mantissa[22] == 0) begin
            b_mantissa <= {1'b1, b_mantissa[21:0]};
            b_exponent <= b_exponent - 1;
        end
        
        // Multiply mantissas
        product_mantissa <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        product_exponent <= a_exponent + b_exponent - 8'd127;
        
        state <= state + 1;
    end
end

// Rounding and normalization
always @(posedge clk) begin
    if (rst) begin
        guard_bit <= 0;
        round_bit <= 0;
        sticky <= 0;
    end else if (state == 2) begin
        // Rounding and normalization
        guard_bit <= product_mantissa[46];
        round_bit <= product_mantissa[45];
        sticky <= |product_mantissa[44:0];
        
        if (guard_bit && (round_bit || sticky)) begin
            // Round up
            product_mantissa[45:0] <= product_mantissa[45:0] + 1;
        end
        
        // Normalize product if needed
        if (product_mantissa[47] == 0) begin
            product_mantissa <= {1'b1, product_mantissa[46:0]};
            product_exponent <= product_exponent - 1;
        end
        
        state <= state + 1;
    end
end

// Format result
always @(posedge clk) begin
    if (rst) begin
        z <= 0;
    end else if (state == 3) begin
        // Format result
        z <= {sign_bit, product_exponent + 8'd127, product_mantissa[22:0]};
        
        // Check for overflow and underflow
        if (product_exponent > 8'd255) begin
            // Overflow
            z <= sign_bit? 32'hff7fffff : 32'h7f7fffff;
        end else if (product_exponent < 8'd1) begin
            // Underflow
            z <= 32'h00000000;
        end
        
        state <= 0;
    end
end

endmodule