module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] stage1, stage2;  // Two-stage pipeline

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            stage1 <= 32'b0;
            stage2 <= 32'b0;
        end else begin
            // Pipeline movement
            stage1 <= in;         // Current input
            stage2 <= stage1;     // Previous input
            
            // Edge detection and latching
            out <= out | (stage2 & ~stage1);  // Compare consecutive stages
        end
    end

endmodule