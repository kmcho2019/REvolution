module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire wrap = (q == 4'd9);

wire [3:0] next_q = wrap ? 4'd0 : q + 1'b1;

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= next_q;
end

endmodule