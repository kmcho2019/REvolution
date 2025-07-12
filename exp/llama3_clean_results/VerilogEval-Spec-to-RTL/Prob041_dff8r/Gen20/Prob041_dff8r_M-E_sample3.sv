module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8;

always_ff @(posedge clk) begin
    if (reset) begin
        stage1 <= 8'b0;
        stage2 <= 8'b0;
        stage3 <= 8'b0;
        stage4 <= 8'b0;
        stage5 <= 8'b0;
        stage6 <= 8'b0;
        stage7 <= 8'b0;
        stage8 <= 8'b0;
    end else begin
        stage1 <= d;
        stage2 <= stage1;
        stage3 <= stage2;
        stage4 <= stage3;
        stage5 <= stage4;
        stage6 <= stage5;
        stage7 <= stage6;
        stage8 <= stage7;
    end
end

assign q = stage8;

endmodule