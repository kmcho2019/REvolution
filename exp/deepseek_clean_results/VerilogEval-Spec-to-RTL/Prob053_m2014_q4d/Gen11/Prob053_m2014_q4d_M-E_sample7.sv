module TopModule (
    input clk,
    input in,
    output out
);

    reg stage1, stage2;
    
    always @(posedge clk) begin
        stage1 <= stage2;          // First stage holds previous output
        stage2 <= in ^ stage1;     // Second stage computes XOR with one-cycle delayed feedback
    end
    
    assign out = stage2;

endmodule