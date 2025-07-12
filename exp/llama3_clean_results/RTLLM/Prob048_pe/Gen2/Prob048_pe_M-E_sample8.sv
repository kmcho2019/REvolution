module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] stage1_reg;
reg [31:0] stage2_reg;
reg [31:0] stage3_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage1_reg <= 0;
        stage2_reg <= 0;
        stage3_reg <= 0;
    end else begin
        stage1_reg <= a * b;
        stage2_reg <= stage1_reg + stage2_reg;
        stage3_reg <= stage2_reg;
    end
end

assign c = stage3_reg;

endmodule