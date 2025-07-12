module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] stage1, stage2, stage3;

always @(posedge clk) begin
    if (reset) begin
        stage1 <= 32'h1;
        stage2 <= 32'h0;
        stage3 <= 32'h0;
    end else begin
        stage1 <= {stage1[30:0], stage1[31] ^ stage1[21] ^ stage1[1] ^ stage1[0]};
        stage2 <= stage1;
        stage3 <= stage2;
        q <= stage3;
    end
end

endmodule