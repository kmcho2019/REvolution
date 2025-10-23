module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire near_terminal = (q >= 10'd992);  // Only check terminal count when close
wire terminal_count = near_terminal & (q == 10'd999);
wire [9:0] next_q = reset ? 10'b0 : 
                   (terminal_count ? 10'b0 : q + 1'b1);

always @(posedge clk) begin
    q <= next_q;
end

endmodule