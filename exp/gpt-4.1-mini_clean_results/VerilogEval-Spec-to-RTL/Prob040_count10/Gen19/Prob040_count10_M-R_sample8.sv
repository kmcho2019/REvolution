module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] q_next;
wire terminal_count;

assign terminal_count = (q == 4'd9);
assign q_next = terminal_count ? 4'd0 : (q + 4'd1);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= q_next;
end

endmodule