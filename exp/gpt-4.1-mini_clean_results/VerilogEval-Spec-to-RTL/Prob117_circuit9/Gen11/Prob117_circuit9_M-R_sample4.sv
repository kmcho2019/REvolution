module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

assign next_q = a ? 3'd4 : ((q == 3'd6) ? 3'd0 : q + 3'd1);

always @(posedge clk) begin
    q <= next_q;
end

endmodule