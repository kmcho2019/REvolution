module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

wire d_in;

assign d_in = r ? 1'b0 : d;

always @(posedge clk) begin
    q <= d_in;
end

endmodule