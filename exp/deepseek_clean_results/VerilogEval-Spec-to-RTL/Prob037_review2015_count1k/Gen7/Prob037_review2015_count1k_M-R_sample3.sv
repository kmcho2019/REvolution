module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire [9:0] next_q;

assign next_q = (q >= 10'd999) ? 10'd0 : q + 1'b1;

always @(posedge clk) begin
    if (reset) q <= 10'd0;
    else q <= next_q;
end

endmodule