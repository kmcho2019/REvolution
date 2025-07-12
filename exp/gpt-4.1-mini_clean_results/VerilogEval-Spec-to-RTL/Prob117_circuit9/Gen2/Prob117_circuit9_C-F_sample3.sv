module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] q_inc;
wire [2:0] q_next;
wire update_enable;

assign q_inc = (q == 3'd6) ? 3'd0 : q + 3'd1;
assign q_next = a ? 3'd4 : q_inc;
assign update_enable = (q_next != q);

always @(posedge clk) begin
    if (update_enable)
        q <= q_next;
end

endmodule