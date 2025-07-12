module TopModule (
    input clk,
    input in,
    output out
);

    reg stage1, stage2;  // Two-stage pipeline registers

    // First stage: XOR with delayed feedback
    always @(posedge clk) begin
        stage1 <= in ^ stage2;
    end

    // Second stage: delay the result
    always @(posedge clk) begin
        stage2 <= stage1;
    end

    assign out = stage2;

endmodule