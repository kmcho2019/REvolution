module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

// Pipeline registers
reg signed [31:0] a_reg, b_reg;
reg signed [63:0] product_reg;
reg valid_reg;

// Shadow accumulator
reg signed [31:0] shadow_acc;

// Clock gating signals
wire mult_enable = |a || |b;
wire acc_enable = valid_reg;

// Booth multiplier pipeline stage 1
always @(posedge clk) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
        valid_reg <= 1'b0;
    end else if (mult_enable) begin
        a_reg <= a;
        b_reg <= b;
        valid_reg <= 1'b1;
    end else begin
        valid_reg <= 1'b0;
    end
end

// Booth multiplier pipeline stage 2
always @(posedge clk) begin
    if (rst) begin
        product_reg <= 64'd0;
    end else if (valid_reg) begin
        // Radix-4 Booth multiplication
        product_reg <= a_reg * b_reg; // Synthesis will infer Booth multiplier
    end
end

// Staggered accumulation
always @(posedge clk) begin
    if (rst) begin
        c <= 32'd0;
        shadow_acc <= 32'd0;
    end else if (acc_enable) begin
        // Only accumulate every other cycle
        shadow_acc <= shadow_acc + product_reg[31:0];
        c <= shadow_acc;
    end
end

endmodule