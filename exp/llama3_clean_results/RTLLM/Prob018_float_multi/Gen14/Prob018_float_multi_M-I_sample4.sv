module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] pipeline_stage; // Pipeline stage counter
reg [23:0] a_mantissa, b_mantissa; // Mantissas of inputs
reg [8:0] a_exponent, b_exponent; // Exponents of inputs
reg a_sign, b_sign; // Sign bits of inputs
reg [47:0] product; // Intermediate product of mantissas
reg [23:0] z_mantissa; // Mantissa of result
reg [7:0] z_exponent; // Exponent of result, adjusted for bias
reg z_sign; // Sign bit of result
reg guard_bit, round_bit, sticky; // Rounding control bits

// Stage 1: Input processing
always @(posedge clk) begin
    if (rst) begin
        pipeline_stage <= 3'b000;
        a_mantissa <= 0;
        a_exponent <= 0;
        a_sign <= 0;
        b_mantissa <= 0;
        b_exponent <= 0;
        b_sign <= 0;
    end else if (pipeline_stage == 3'b000) begin
        // Extract mantissas, exponents, and signs from inputs
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
        pipeline_stage <= pipeline_stage + 1;
    end
end

// Stage 2: Special case handling
always @(posedge clk) begin
    if (pipeline_stage == 3'b001) begin
        // Handle special cases: NaN, infinity, and zero
        if (a_exponent == 8'd255 || b_exponent == 8'd255) begin
            // NaN or infinity
            if (a_exponent == 8'd255 && a_mantissa != 0) begin
                // NaN
                z <= 32'b1;
            end else if (b_exponent == 8'd255 && b_mantissa != 0) begin
                // NaN
                z <= 32'b1;
            end else if (a_exponent == 8'd255 && a_mantissa == 0) begin
                // Infinity
                z <= (a_sign == 1) ? 32'hff800000 : 32'h7f800000;
            end else if (b_exponent == 8'd255 && b_mantissa == 0) begin
                // Infinity
                z <= (b_sign == 1) ? 32'hff800000 : 32'h7f800000;
            end
            pipeline_stage <= 3'b100; // Bypass further stages for special cases
        end else if (a_exponent == 0 && a_mantissa == 0) begin
            // a is zero
            z <= 32'b0;
            pipeline_stage <= 3'b100; // Bypass further stages for zero
        end else if (b_exponent == 0 && b_mantissa == 0) begin
            // b is zero
            z <= 32'b0;
            pipeline_stage <= 3'b100; // Bypass further stages for zero
        end else begin
            pipeline_stage <= pipeline_stage + 1;
        end
    end
end

// Stage 3: Mantissa multiplication and exponent calculation
always @(posedge clk) begin
    if (pipeline_stage == 3'b010) begin
        // Multiply mantissas and calculate exponent
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        z_exponent <= a_exponent + b_exponent - 8'd127;
        pipeline_stage <= pipeline_stage + 1;
    end
end

// Stage 4: Rounding and normalization
always @(posedge clk) begin
    if (pipeline_stage == 3'b011) begin
        // Perform rounding and normalization
        guard_bit <= product[23];
        round_bit <= product[22];
        sticky <= |product[21:0];
        if (round_bit && (guard_bit || sticky)) begin
            z_mantissa <= product[47:24] + 1;
        end else begin
            z_mantissa <= product[47:24];
        end
        z_sign <= a_sign ^ b_sign;
        pipeline_stage <= pipeline_stage + 1;
    end
end

// Stage 5: Output generation
always @(posedge clk) begin
    if (pipeline_stage == 3'b100) begin
        // Generate output
        z <= {z_sign, z_exponent, z_mantissa};
        pipeline_stage <= 3'b000; // Reset pipeline stage
    end
end

endmodule