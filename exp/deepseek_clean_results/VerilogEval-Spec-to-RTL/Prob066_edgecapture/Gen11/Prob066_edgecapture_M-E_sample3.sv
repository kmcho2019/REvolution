module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] stage1, stage2;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            stage1 <= 32'b0;
            stage2 <= 32'b0;
        end
        else begin
            // Two-stage pipeline for reliable edge detection
            stage2 <= stage1;
            stage1 <= in;
            
            // Detect falling edge (1 in stage2, 0 in stage1)
            // and latch the output until reset
            out <= out | (stage2 & ~stage1);
        end
    end

endmodule