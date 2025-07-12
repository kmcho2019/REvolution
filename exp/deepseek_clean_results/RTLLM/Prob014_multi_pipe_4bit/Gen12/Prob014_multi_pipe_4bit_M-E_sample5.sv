module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Stage 1: Partial product generation
reg [7:0] pp0, pp1, pp2, pp3;
reg [7:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;

// Generate all partial products in parallel
always @(*) begin
    pp0 = mul_b[0] ? {4'b0, mul_a} : 8'b0;
    pp1 = mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0;
    pp2 = mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0;
    pp3 = mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0;
end

// Register partial products at stage 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0_reg <= 8'b0;
        pp1_reg <= 8'b0;
        pp2_reg <= 8'b0;
        pp3_reg <= 8'b0;
    end else begin
        pp0_reg <= pp0;
        pp1_reg <= pp1;
        pp2_reg <= pp2;
        pp3_reg <= pp3;
    end
end

// Stage 2: Carry-save addition
reg [7:0] sum1, carry1;
reg [7:0] sum1_reg, carry1_reg;

// First level of carry-save adders
always @(*) begin
    {carry1[6:0], sum1} = pp0_reg + pp1_reg;
    carry1[7] = 1'b0;
end

// Second level of carry-save adders
reg [7:0] sum2, carry2;

always @(*) begin
    {carry2[6:0], sum2} = sum1 + pp2_reg;
    carry2[7] = 1'b0;
    carry2 = carry2 | (carry1 << 1);
end

// Register intermediate sums and carries
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1_reg <= 8'b0;
        carry1_reg <= 8'b0;
    end else begin
        sum1_reg <= sum2;
        carry1_reg <= carry2;
    end
end

// Final stage: Combine sum and carry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum1_reg + (carry1_reg << 1) + pp3_reg;
    end
end

endmodule