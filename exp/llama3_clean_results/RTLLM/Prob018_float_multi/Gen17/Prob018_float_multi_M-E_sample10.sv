module float_multi_pipelined(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] stage_counter; // Stage counter for pipelined processing
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

// Stage 1: Input Processing
always @(posedge clk) begin
    if (rst) begin
        stage_counter <= 3'b000;
        a_sign <= 0;
        a_exponent <= 0;
        a_mantissa <= 0;
        b_sign <= 0;
        b_exponent <= 0;
        b_mantissa <= 0;
    end else if (stage_counter == 3'b000) begin
        // Extract sign bits, exponents, and mantissas from inputs
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
        stage_counter <= stage_counter + 1;
    end
end

// Stage 2: Exponent Calculation
always @(posedge clk) begin
    if (stage_counter == 3'b001) begin
        // Calculate exponent of product
        product_exponent <= a_exponent + b_exponent - 8'd127;
        stage_counter <= stage_counter + 1;
    end
end

// Stage 3: Mantissa Multiplication
always @(posedge clk) begin
    if (stage_counter == 3'b010) begin
        // Perform digit-serial multiplication of mantissas
        reg [22:0] partial_product;
        partial_product <= 0;
        for (int i = 0; i < 23; i++) begin
            partial_product <= partial_product + (a_mantissa[i] ? b_mantissa : 0);
        end
        product_mantissa <= partial_product;
        stage_counter <= stage_counter + 1;
    end
end

// Stage 4: Normalization
always @(posedge clk) begin
    if (stage_counter == 3'b011) begin
        // Normalize product mantissa
        normalized_mantissa <= product_mantissa;
        normalized_exponent <= product_exponent;
        stage_counter <= stage_counter + 1;
    end
end

// Stage 5: Rounding
always @(posedge clk) begin
    if (stage_counter == 3'b100) begin
        // Round normalized mantissa
        rounded_mantissa <= normalized_mantissa;
        rounded_exponent <= normalized_exponent;
        stage_counter <= stage_counter + 1;
    end
end

// Stage 6: Output
always @(posedge clk) begin
    if (stage_counter == 3'b101) begin
        // Format output
        z <= {a_sign ^ b_sign, rounded_exponent, rounded_mantissa};
        stage_counter <= 3'b000; // Reset stage counter
    end
end

endmodule