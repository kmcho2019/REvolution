module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

assign next_q = a ? 3'd4 : (
    (q == 3'd4) ? 3'd5 :
    (q == 3'd5) ? 3'd6 :
    (q == 3'd6) ? 3'd0 :
    (q == 3'd0) ? 3'd1 :
    (q == 3'd1) ? 3'd2 :
    (q == 3'd2) ? 3'd3 :
    3'd4 // default case if q is 3'd3 or others
);

always @(posedge clk) begin
    q <= next_q;
end

endmodule