module multi_pipe_8bit(
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
reg [2:0] count;
reg mul_en_out_reg;

// Pipeline stage 1: Input registers
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Pipeline stage 2: Partial product generation
reg [15:0] partial_product;
always @(posedge clk) begin
    if (!rst_n) begin
        partial_product <= 16'b0;
    end else if (mul_en_in) begin
        partial_product <= 16'b0;
    end else if (count < 3'b111 && mul_en_out_reg) begin
        if (mul_b_reg[count]) begin
            partial_product <= partial_product + (mul_a_reg << count);
        end
    end
end

// Pipeline stage 3: Partial sum calculation
reg [15:0] partial_sum;
always @(posedge clk) begin
    if (!rst_n) begin
        partial_sum <= 16'b0;
    end else if (mul_en_in) begin
        partial_sum <= 16'b0;
    end else if (count < 3'b111 && mul_en_out_reg) begin
        partial_sum <= partial_sum + partial_product;
    end
end

// Pipeline stage 4: Final product calculation
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
        count <= 3'b000;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= 16'b0;
        count <= 3'b000;
        mul_en_out_reg <= 1'b1;
    end else if (count < 3'b111 && mul_en_out_reg) begin
        if (mul_b_reg[count]) begin
            mul_out_reg <= mul_out_reg + (mul_a_reg << count);
        end
        count <= count + 1'b1;
    end else if (count == 3'b111 && mul_en_out_reg) begin
        mul_en_out_reg <= 1'b0;
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_out_reg;

endmodule