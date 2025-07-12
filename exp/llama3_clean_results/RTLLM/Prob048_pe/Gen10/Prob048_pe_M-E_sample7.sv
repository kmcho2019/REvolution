module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Modified Booth Multiplier
reg [31:0] product;
always @(posedge clk) begin
    if (rst) begin
        product <= 32'd0;
    end else begin
        product <= a * b;
    end
end

// Pipelined Accumulation Stage
reg [31:0] stage1, stage2, stage3;
always @(posedge clk) begin
    if (rst) begin
        stage1 <= 32'd0;
        stage2 <= 32'd0;
        stage3 <= 32'd0;
    end else begin
        stage1 <= product;
        stage2 <= stage1;
        stage3 <= stage2 + stage1;
    end
end

// Optimized Reset Mechanism
reg [31:0] c_reg;
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + stage3;
    end
end

// Output Assignment
assign c = c_reg;

endmodule