module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Operand Pre-processing
reg [31:0] pre_a, pre_b;
reg pre_rst;
always @(posedge clk) begin
    if (rst) begin
        pre_a <= 0;
        pre_b <= 0;
        pre_rst <= 1'b1;
    end else begin
        pre_a <= a;
        pre_b <= b;
        pre_rst <= 1'b0;
    end
end

// Dynamic Pipeline Reconfiguration
reg [2:0] pipeline_config;
always @(posedge clk) begin
    if (pre_rst) begin
        pipeline_config <= 3'b000;
    end else begin
        // Determine pipeline configuration based on input operands
        if (pre_a[31] && pre_b[31]) begin
            pipeline_config <= 3'b001; // Both negative
        end else if (!pre_a[31] &&!pre_b[31]) begin
            pipeline_config <= 3'b010; // Both positive
        end else begin
            pipeline_config <= 3'b011; // Mixed signs
        end
    end
end

// Mantissa Multiplier Array
reg [23:0] mantissa_product;
reg [7:0] exponent_sum;
always @(posedge clk) begin
    if (pipeline_config == 3'b001 || pipeline_config == 3'b010) begin
        // Multiply mantissas and calculate exponent sum
        mantissa_product <= pre_a[22:0] * pre_b[22:0];
        exponent_sum <= pre_a[30:23] + pre_b[30:23];
    end else begin
        // Handle mixed signs or special cases
        mantissa_product <= 0;
        exponent_sum <= 0;
    end
end

// Exponent and Sign Processing
reg [7:0] final_exponent;
reg final_sign;
always @(posedge clk) begin
    if (pipeline_config == 3'b001) begin
        final_exponent <= exponent_sum - 8'd127;
        final_sign <= 1'b1;
    end else if (pipeline_config == 3'b010) begin
        final_exponent <= exponent_sum - 8'd127;
        final_sign <= 1'b0;
    end else begin
        final_exponent <= 0;
        final_sign <= 0;
    end
end

// Rounding and Post-processing
reg [31:0] final_result;
always @(posedge clk) begin
    if (final_exponent > 8'd254) begin
        final_result <= (final_sign)? 32'hff800000 : 32'h7f800000; // Overflow
    end else if (final_exponent < 8'd1) begin
        final_result <= {final_sign, 8'b0, mantissa_product[22:0]}; // Underflow or denormalized
    end else begin
        final_result <= {final_sign, final_exponent, mantissa_product[22:0]}; // Normalized result
    end
end

// Clock Domain Crossing (CDC)
reg [31:0] cdc_result;
always @(posedge clk) begin
    cdc_result <= final_result;
end

assign z = cdc_result;

endmodule