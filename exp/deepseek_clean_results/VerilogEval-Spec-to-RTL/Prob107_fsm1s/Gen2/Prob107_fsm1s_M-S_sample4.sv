module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b1; // Reset to state B (out=1)
        end else begin
            out <= in ? out : ~out; // Toggle state only when in=0
        end
    end

endmodule