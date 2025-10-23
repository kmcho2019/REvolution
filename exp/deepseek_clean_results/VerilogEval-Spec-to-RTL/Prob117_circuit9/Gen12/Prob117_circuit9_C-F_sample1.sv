module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q = (q == 3'd6) ? 3'd0 : (q + 1'b1);

always @(posedge clk) begin
    q <= a ? 3'd4 : next_q;
end

endmodule