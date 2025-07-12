module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire terminal_count = (q == 4'd9);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= terminal_count ? 4'd0 : q + 4'd1;
end

endmodule