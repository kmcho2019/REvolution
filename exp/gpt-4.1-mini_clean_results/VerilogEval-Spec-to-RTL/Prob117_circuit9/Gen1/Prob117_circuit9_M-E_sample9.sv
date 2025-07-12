module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] q_next;
wire [2:0] q_inc;

assign q_inc = (q == 3'd6) ? 3'd0 : q + 3'd1;
assign q_next = a ? 3'd4 : q_inc;

always @(posedge clk) begin
    q <= q_next;
end

endmodule