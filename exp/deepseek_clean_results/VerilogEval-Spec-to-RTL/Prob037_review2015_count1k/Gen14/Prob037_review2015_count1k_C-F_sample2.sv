module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire terminal_count = (q[9:5] == 5'b11111) & (q[4:0] == 5'b00111);

always @(posedge clk) begin
    if (reset) q <= 10'd0;
    else q <= terminal_count ? 10'd0 : q + 1'b1;
end

endmodule