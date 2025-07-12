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
reg [2:0] counter;
reg [15:0] result;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        counter <= 3'b0;
        result <= 16'b0;
        mul_en_out <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        counter <= 3'b0;
        result <= 16'b0;
        mul_en_out <= 1'b1;
    end else if (counter < 8) begin
        if (mul_b_reg[counter] == 1'b1) begin
            result <= result + (mul_a_reg << counter);
        end
        counter <= counter + 1'b1;
    end else begin
        mul_out <= result;
        mul_en_out <= 1'b0;
    end
end

endmodule