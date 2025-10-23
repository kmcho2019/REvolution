module TopModule (
    input  wire clk,
    input  wire d,
    input  wire r,
    output reg  q
);

reg next_q;

always @(*) begin
    next_q = r ? 1'b0 : d;
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule