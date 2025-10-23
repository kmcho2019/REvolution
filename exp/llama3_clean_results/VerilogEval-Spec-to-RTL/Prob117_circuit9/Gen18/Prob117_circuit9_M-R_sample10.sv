module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

assign next_q = (a)? 4 : (q == 6)? 0 : q + 1;

always @(posedge clk) begin
    q <= next_q;
end

initial q = 4;

endmodule