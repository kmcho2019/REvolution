module multi_pipe_8bit_new(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg mul_en_out_reg;

// Input Buffer
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Booth Multiplier (4-stage pipeline)
reg [15:0] pp1, pp2, pp3, pp4;
always @(posedge clk) begin
    if (!rst_n) begin
        pp1 <= 16'b0;
        pp2 <= 16'b0;
        pp3 <= 16'b0;
        pp4 <= 16'b0;
    end else if (mul_en_in) begin
        // Stage 1: Partial product generation
        pp1 <= (mul_a_reg << 0) * (mul_b_reg[0]);
        // Stage 2: Partial product generation
        pp2 <= (mul_a_reg << 1) * (mul_b_reg[1]);
        // Stage 3: Partial product generation
        pp3 <= (mul_a_reg << 2) * (mul_b_reg[2]);
        // Stage 4: Partial product generation
        pp4 <= (mul_a_reg << 3) * (mul_b_reg[3]);
    end else begin
        // Stage 1: Partial product accumulation
        pp1 <= pp1 + (mul_a_reg << 4) * (mul_b_reg[4]);
        // Stage 2: Partial product accumulation
        pp2 <= pp2 + (mul_a_reg << 5) * (mul_b_reg[5]);
        // Stage 3: Partial product accumulation
        pp3 <= pp3 + (mul_a_reg << 6) * (mul_b_reg[6]);
        // Stage 4: Partial product accumulation
        pp4 <= pp4 + (mul_a_reg << 7) * (mul_b_reg[7]);
    end
end

// Partial Product Accumulator
reg [15:0] sum1, sum2, sum3;
always @(posedge clk) begin
    if (!rst_n) begin
        sum1 <= 16'b0;
        sum2 <= 16'b0;
        sum3 <= 16'b0;
    end else if (mul_en_in) begin
        sum1 <= pp1;
        sum2 <= pp2;
        sum3 <= pp3;
    end else begin
        sum1 <= sum1 + pp2;
        sum2 <= sum2 + pp3;
        sum3 <= sum3 + pp4;
    end
end

// Output Register
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= 16'b0;
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_out_reg <= sum1 + sum2 + sum3;
        mul_en_out_reg <= 1'b0;
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_out_reg;

endmodule