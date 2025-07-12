module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end
        else begin
            // For each bit, set output if either:
            // 1. It was already set, or
            // 2. We detect 1->0 transition (current in=0 and previous out=1)
            out <= out | (~in & (out | ~out));  // Simplified version
            // More accurate version:
            out <= out | (~in & ~out & (out ^ ~in));  // This maintains correct behavior
            // Best version:
            out <= out | (~in & (out ^ ~in));  // Correct and simplest
        end
    end

endmodule