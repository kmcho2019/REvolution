module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] stage_counter; // Stage counter for the hybrid multiplier
reg [22:0] a_mantissa, b_mantissa; // Mantissas of inputs
reg [7:0] a_exponent, b_exponent; // Exponents of inputs
reg a_sign, b_sign; // Sign bits of inputs
reg [45:0] product; // Intermediate product of mantissas
reg [22:0] z_mantissa; // Mantissa of result
reg [7:0] z_exponent; // Exponent of result, adjusted for bias
reg z_sign; // Sign bit of result
reg [22:0] partial_product [3:0]; // Partial products for hybrid multiplication
reg [2:0] segment_counter; // Counter for segment-wise multiplication

// Stage 1: Pre-processing
always @(posedge clk) begin
    if (rst) begin
        stage_counter <= 3'b000;
        a_mantissa <= 0;
        a_exponent <= 0;
        a_sign <= 0;
        b_mantissa <= 0;
        b_exponent <= 0;
        b_sign <= 0;
    end else if (stage_counter == 3'b000) begin
        // Extract mantissas, exponents, and signs from inputs
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
        stage_counter <= stage_counter + 1;
    end
end

// Stage 2: Hybrid multiplication
always @(posedge clk) begin
    if (stage_counter == 3'b001) begin
        // Split mantissas into segments for hybrid multiplication
        reg [7:0] a_segment [3:0];
        reg [7:0] b_segment [3:0];
        for (int i = 0; i < 4; i++) begin
            a_segment[i] <= a_mantissa[(i * 7) +: 7];
            b_segment[i] <= b_mantissa[(i * 7) +: 7];
        end
        // Multiply segments in parallel
        for (int i = 0; i < 4; i++) begin
            partial_product[i] <= {8'b0, a_segment[i]} * {8'b0, b_segment[i]};
        end
        stage_counter <= stage_counter + 1;
    end
end

// Stage 3: Accumulation and exponent calculation
always @(posedge clk) begin
    if (stage_counter == 3'b010) begin
        // Accumulate partial products
        reg [45:0] accumulated_product;
        accumulated_product <= 0;
        for (int i = 0; i < 4; i++) begin
            accumulated_product <= accumulated_product + partial_product[i];
        end
        product <= accumulated_product;
        // Calculate exponent
        z_exponent <= a_exponent + b_exponent - 8'd127;
        stage_counter <= stage_counter + 1;
    end
end

// Stage 4: Rounding and normalization
always @(posedge clk) begin
    if (stage_counter == 3'b011) begin
        // Perform rounding and normalization
        reg [22:0] rounded_mantissa;
        rounded_mantissa <= product[45:23];
        if (product[22] && (product[21] || |product[20:0])) begin
            rounded_mantissa <= rounded_mantissa + 1;
        end
        z_mantissa <= rounded_mantissa;
        z_sign <= a_sign ^ b_sign;
        stage_counter <= stage_counter + 1;
    end
end

// Stage 5: Output generation
always @(posedge clk) begin
    if (stage_counter == 3'b100) begin
        // Generate output
        z <= {z_sign, z_exponent, z_mantissa};
        stage_counter <= 3'b000; // Reset stage counter
    end
end

// Special case handling
always @(posedge clk) begin
    if (a_exponent == 8'd255 || b_exponent == 8'd255) begin
        // Handle NaN and infinity
        if (a_exponent == 8'd255 && a_mantissa != 0) begin
            z <= 32'd0; // NaN
        end else if (b_exponent == 8'd255 && b_mantissa != 0) begin
            z <= 32'd0; // NaN
        end else if (a_exponent == 8'd255 && a_mantissa == 0) begin
            z <= {a_sign, 8'd255, 23'd0}; // Infinity
        end else if (b_exponent == 8'd255 && b_mantissa == 0) begin
            z <= {b_sign, 8'd255, 23'd0}; // Infinity
        end
    end
end

endmodule