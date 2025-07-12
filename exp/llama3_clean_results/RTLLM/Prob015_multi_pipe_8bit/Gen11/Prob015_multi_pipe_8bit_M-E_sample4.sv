module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] partial_product;
reg [15:0] partial_sum;
reg [15:0] final_product;
reg mul_en_out_reg;

// Stage 1: Input Control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end
end

// Stage 2: Partial Product Generation
always @(posedge clk) begin
    if (mul_en_out_reg) begin
        partial_product <= 16'b0;
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                partial_product <= partial_product + (mul_a_reg << i);
            end
        end
    end
end

// Stage 3: Partial Sum Calculation
always @(posedge clk) begin
    if (mul_en_out_reg) begin
        partial_sum <= partial_product;
    end
end

// Stage 4: Final Product Calculation
always @(posedge clk) begin
    if (mul_en_out_reg) begin
        final_product <= partial_sum;
    end
end

// Output Assignment
always @(posedge clk) begin
    if (mul_en_out_reg) begin
        mul_en_out <= 1'b1;
        mul_out <= final_product;
    end else begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end
end

endmodule