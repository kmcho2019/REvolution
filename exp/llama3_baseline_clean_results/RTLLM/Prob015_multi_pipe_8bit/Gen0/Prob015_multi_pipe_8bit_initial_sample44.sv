module multi_pipe_8bit (
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
reg mul_en_out_reg;
reg [15:0] sum;
reg [15:0] mul_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_out_reg <= 16'd0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= mul_en_in;
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

always @(posedge clk) begin
    sum <= 16'd0;
    for (i = 0; i < 8; i = i + 1) begin
        if (mul_b_reg[i]) begin
            sum <= sum + (mul_a_reg << i);
        end
    end
    mul_out_reg <= sum;
end

always @(posedge clk) begin
    mul_en_out <= mul_en_out_reg;
    if (mul_en_out_reg) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'd0;
    end
end

endmodule