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
            // Detect falling edges (current input 0 when output bit was 1)
            // and maintain all previously detected edges
            out <= out | (~in & (out | ~(out ^ in)));
        end
    end

endmodule