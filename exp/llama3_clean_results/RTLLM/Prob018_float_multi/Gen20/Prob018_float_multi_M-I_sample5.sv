module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] state; // State machine for the multiplication process
reg a_sign, b_sign; // Sign bits of inputs
reg [7:0] a_exponent, b_exponent; // Exponents of inputs
reg [22:0] a_mantissa, b_mantissa; // Mantissas of inputs
reg [22:0] product_mantissa; // Mantissa of product
reg [7:0] product_exponent; // Exponent of product
reg product_sign; // Sign bit of product
reg [22:0] normalized_mantissa; // Normalized mantissa
reg [7:0] normalized_exponent; // Normalized exponent
reg [22:0] rounded_mantissa; // Rounded mantissa
reg [7:0] rounded_exponent; // Rounded exponent

// Input processing
always @(posedge clk) begin
    if (rst) begin
        a_sign <= 1'b0;
        a_exponent <= 8'd0;
        a_mantissa <= 23'd0;
        b_sign <= 1'b0;
        b_exponent <= 8'd0;
        b_mantissa <= 23'd0;
    end else if (state == 3'b000) begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
        state <= 3'b001; // Move to exponent calculation
    end
end

// Exponent calculation
always @(posedge clk) begin
    if (rst) begin
        product_exponent <= 8'd0;
    end else if (state == 3'b001) begin
        product_exponent <= a_exponent + b_exponent - 8'd127;
        state <= 3'b010; // Move to mantissa multiplication
    end
end

// Mantissa multiplication
always @(posedge clk) begin
    if (rst) begin
        product_mantissa <= 23'd0;
    end else if (state == 3'b010) begin
        product_mantissa <= a_mantissa * b_mantissa;
        state <= 3'b011; // Move to normalization
    end
end

// Normalization
always @(posedge clk) begin
    if (rst) begin
        normalized_mantissa <= 23'd0;
        normalized_exponent <= 8'd0;
    end else if (state == 3'b011) begin
        normalized_mantissa <= product_mantissa;
        normalized_exponent <= product_exponent;
        state <= 3'b100; // Move to rounding
    end
end

// Rounding
always @(posedge clk) begin
    if (rst) begin
        rounded_mantissa <= 23'd0;
        rounded_exponent <= 8'd0;
    end else if (state == 3'b100) begin
        if (normalized_mantissa[22]) begin
            rounded_mantissa <= normalized_mantissa >> 1;
            rounded_exponent <= normalized_exponent + 1;
        end else begin
            rounded_mantissa <= normalized_mantissa;
            rounded_exponent <= normalized_exponent;
        end
        state <= 3'b101; // Move to output formatting
    end
end

// Output formatting
always @(posedge clk) begin
    if (rst) begin
        z <= 32'd0;
    end else if (state == 3'b101) begin
        z <= {a_sign ^ b_sign, rounded_exponent, rounded_mantissa};
        state <= 3'b000; // Reset state machine
    end
end

// Special case handling for NaN and infinity
always @(posedge clk) begin
    if (rst) begin
        z <= 32'd0;
    end else if ((a_exponent == 8'd255 && a_mantissa != 23'd0) || (b_exponent == 8'd255 && b_mantissa != 23'd0)) begin
        z <= 32'd0; // Handling NaN
    end else if ((a_exponent == 8'd255 && a_mantissa == 23'd0) || (b_exponent == 8'd255 && b_mantissa == 23'd0)) begin
        z <= {1'b1, 8'd255, 23'd0}; // Handling infinity
    end
end

endmodule