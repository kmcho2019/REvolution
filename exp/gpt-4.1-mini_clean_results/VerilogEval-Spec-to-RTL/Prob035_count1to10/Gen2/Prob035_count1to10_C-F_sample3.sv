module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Always enabled counting (count_enable tied to 1)
    wire count_enable = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;  // synchronous reset to 1
        end else if (count_enable) begin
            q <= (q == 4'd10) ? 4'd1 : q + 4'd1;
        end
    end

endmodule