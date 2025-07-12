module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

reg [7:0] stage1_out;
reg [7:0] stage2_out;
reg [7:0] mul_out_reg;

integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_out <= 0;
        stage2_out <= 0;
        mul_out_reg <= 0;
    end else begin
        stage1_out <= 0;
        for (i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                stage1_out = stage1_out + (mul_a << i);
            end
        end
        stage2_out <= stage1_out;
        mul_out_reg <= stage2_out;
    end
end

assign mul_out = mul_out_reg;

endmodule