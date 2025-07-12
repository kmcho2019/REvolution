module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [7:0] stage0, stage1, stage2, stage3, stage4, stage5, stage6, stage7;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage0 <= 8'd0;
        stage1 <= 8'd0;
        stage2 <= 8'd0;
        stage3 <= 8'd0;
        stage4 <= 8'd0;
        stage5 <= 8'd0;
        stage6 <= 8'd0;
        stage7 <= 8'd0;
    end else begin
        stage0 <= (stage0[0] == 1'b0) ? {1'b1, stage0[7:1]} : {1'b0, stage0[7:1]};
        stage1 <= stage0;
        stage2 <= stage1;
        stage3 <= stage2;
        stage4 <= stage3;
        stage5 <= stage4;
        stage6 <= stage5;
        stage7 <= stage6;
    end
end

assign Q = {stage7, stage6, stage5, stage4, stage3, stage2, stage1, stage0};

endmodule