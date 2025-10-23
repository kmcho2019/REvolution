module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    next_q = reset ? 4'd0 :
             (slowena ? ((q == 4'd9) ? 4'd0 : q + 4'd1) : q);
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule