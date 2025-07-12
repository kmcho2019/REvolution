module TopModule (
    input  wire clk,
    input  wire d,
    input  wire r,
    output reg  q
);

always @(posedge clk) begin
    reg next_q;
    next_q <= r ? 1'b0 : d;
    q <= next_q;
end

endmodule