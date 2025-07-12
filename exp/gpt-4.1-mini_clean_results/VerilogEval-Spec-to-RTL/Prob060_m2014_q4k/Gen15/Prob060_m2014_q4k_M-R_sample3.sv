module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    reg stage0, stage1, stage2, stage3;

    always @(posedge clk) begin
        if (~resetn) begin
            stage0 <= 1'b0;
            stage1 <= 1'b0;
            stage2 <= 1'b0;
            stage3 <= 1'b0;
        end else begin
            stage0 <= in;
            stage1 <= stage0;
            stage2 <= stage1;
            stage3 <= stage2;
        end
    end

    assign out = stage3;
endmodule