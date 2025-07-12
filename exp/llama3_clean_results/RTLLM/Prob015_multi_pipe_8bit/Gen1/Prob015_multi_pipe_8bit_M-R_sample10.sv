module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output reg [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] sum_reg;

assign mul_en_out = mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        sum_reg <= 16'b0;
    end else begin
        mul_en_out_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        // Initialize sum_reg to 0 on each new multiplication
        if (mul_en_in) begin
            sum_reg <= 16'b0;
        end else begin
            // Accumulate partial products
            reg [15:0] partial_sum;
            partial_sum = 16'b0;
            for (int i = 0; i < 8; i++) begin
                if (mul_b_reg[i]) begin
                    partial_sum = partial_sum + (mul_a_reg << i);
                end
            end
            sum_reg <= partial_sum;
        end
    end
end

always @(posedge clk) begin
    if (mul_en_out_reg) begin
        mul_out <= sum_reg;
    end else begin
        mul_out <= 16'b0;
    end
end

endmodule