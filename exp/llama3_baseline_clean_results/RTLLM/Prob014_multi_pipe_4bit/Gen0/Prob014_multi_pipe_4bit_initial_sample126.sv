module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] stage1 [3:0];
reg [7:0] stage2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 4; i++) begin
            stage1[i] <= 8'd0;
        end
        stage2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        for (i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                stage1[i] <= {4'd0, mul_a} << i;
            end else begin
                stage1[i] <= 8'd0;
            end
        end
        
        stage2 <= stage1[0] + stage1[1] + stage1[2] + stage1[3];
        
        mul_out <= stage2;
    end
end

endmodule