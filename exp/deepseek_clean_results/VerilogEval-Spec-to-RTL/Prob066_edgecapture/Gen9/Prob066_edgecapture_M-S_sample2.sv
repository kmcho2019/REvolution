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
            // For bits not already set, detect falling edges
            out <= out | (~out & (out & ~in));
        end
    end

endmodule