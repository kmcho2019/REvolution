module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [31:0] a_sign, a_exponent, a_mantissa;
reg [31:0] b_sign, b_exponent, b_mantissa;
reg [31:0] product_sign, product_exponent, product_mantissa;
reg [49:0] product; // For 23-bit mantissa multiplication
reg [22:0] normalized_mantissa;
reg [7:0] normalized_exponent;
reg [22:0] rounded_mantissa;
reg [7:0] rounded_exponent;
reg is_nan, is_inf; // Flags for NaN and infinity

// Input stage
always @(posedge clk) begin
    if (rst) begin
        a_sign <= 1'b0;
        a_exponent <= 8'd0;
        a_mantissa <= 23'd0;
        b_sign <= 1'b0;
        b_exponent <= 8'd0;
        b_mantissa <= 23'd0;
    end else begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= {1'b1, a[22:0]}; // Implicit 1 for normalized numbers
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= {1'b1, b[22:0]}; // Implicit 1 for normalized numbers
    end
end

// Exponent calculation stage
always @(posedge clk) begin
    if (rst) begin
        product_exponent <= 8'd0;
    end else begin
        product_exponent <= a_exponent + b_exponent - 8'd127;
    end
end

// Mantissa multiplication stage
always @(posedge clk) begin
    if (rst) begin
        product <= 50'd0;
    end else begin
        product <= (a_mantissa * b_mantissa);
    end
end

// Normalization and rounding stage
always @(posedge clk) begin
    if (rst) begin
        normalized_mantissa <= 23'd0;
        normalized_exponent <= 8'd0;
        rounded_mantissa <= 23'd0;
        rounded_exponent <= 8'd0;
    end else begin
        // Normalization
        if (product[49]) begin // MSB set, no shift needed
            normalized_mantissa <= product[49:27];
            normalized_exponent <= product_exponent;
        end else begin // MSB not set, shift left
            normalized_mantissa <= product[48:26];
            normalized_exponent <= product_exponent + 1;
        end
        
        // Rounding (simplified, actual implementation may vary based on rounding mode)
        rounded_mantissa <= normalized_mantissa;
        rounded_exponent <= normalized_exponent;
    end
end

// Output stage
always @(posedge clk) begin
    if (rst) begin
        z <= 32'd0;
    end else begin
        // Assemble output
        z <= {a_sign ^ b_sign, rounded_exponent, rounded_mantissa[22:0]};
    end
end

// Special case handling for NaN and infinity
always @(posedge clk) begin
    if (rst) begin
        is_nan <= 1'b0;
        is_inf <= 1'b0;
    end else begin
        // Check for NaN
        if ((a_exponent == 8'd255 && a_mantissa != 23'd0) || (b_exponent == 8'd255 && b_mantissa != 23'd0)) begin
            is_nan <= 1'b1;
        end
        
        // Check for infinity
        if ((a_exponent == 8'd255 && a_mantissa == 23'd0) || (b_exponent == 8'd255 && b_mantissa == 23'd0)) begin
            is_inf <= 1'b1;
        end
    end
end

// Assign NaN or infinity if detected
always @(posedge clk) begin
    if (is_nan) begin
        z <= 32'd0; // Replace with actual NaN representation
    end else if (is_inf) begin
        z <= 32'd0; // Replace with actual infinity representation
    end
end

endmodule