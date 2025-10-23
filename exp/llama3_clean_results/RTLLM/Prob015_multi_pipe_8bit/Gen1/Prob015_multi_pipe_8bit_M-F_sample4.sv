module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [15:0] sum_reg[7:0]; // Array of registers for storing partial sums

assign mul_en_out = mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        for (int i = 0; i < 8; i++) begin
            sum_reg[i] <= 16'b0;
        end
        mul_out_reg <= 16'b0;
    end else begin
        mul_en_out_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        
        // Partial product generation and sum calculation
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                sum_reg[i] <= (mul_b_reg[0] ? mul_a_reg : 16'b0);
            end else begin
                sum_reg[i] <= sum_reg[i-1] + (mul_b_reg[i] ? (mul_a_reg << i) : 16'b0);
            end
        end
        
        // Final product calculation
        mul_out_reg <= sum_reg[7];
    end
end

always @(posedge clk) begin
    if (mul_en_out_reg) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'b0;
    end
end

endmodule