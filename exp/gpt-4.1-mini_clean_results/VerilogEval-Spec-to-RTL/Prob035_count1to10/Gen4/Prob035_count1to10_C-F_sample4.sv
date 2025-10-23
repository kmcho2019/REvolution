module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire count_enable = ~reset;

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;  // synchronous reset to 1
        end else if (count_enable) begin
            q <= (q == 4'd10) ? 4'd1 : q + 4'd1;
        end
    end

endmodule