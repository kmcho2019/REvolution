module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire terminal_count = (q == 10'd999);
wire [9:0] next_q = (reset || terminal_count) ? 10'b0 : q + 1'b1;

always @(posedge clk) begin
    q <= next_q;
end

endmodule