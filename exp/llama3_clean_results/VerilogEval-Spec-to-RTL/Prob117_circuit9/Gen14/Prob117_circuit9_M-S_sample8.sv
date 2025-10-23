module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    q <= (a)? 4 : ((q < 6)? (q + 1) : 0);
end

initial q = 4;

endmodule