module DFlipFlop(
    input  clk,
    input  d,
    output reg q = 1'b0
);

always_ff @(posedge clk) begin
    q <= d;
end

endmodule

module NOR3(
    input  a,
    input  b,
    input  c,
    output z
);

assign z = ~(a | b | c);

endmodule

module TopModule(
    input  clk,
    input  x,
    output z
);

reg q1 = 1'b0, q2 = 1'b0, q3 = 1'b0;
wire d1, d2, d3;

always_comb begin
    d1 = x ^ q1;
    d2 = x & ~q2;
    d3 = x | ~q3;
end

DFlipFlop ff1(clk, d1, q1);
DFlipFlop ff2(clk, d2, q2);
DFlipFlop ff3(clk, d3, q3);

NOR3 nor(q1, q2, q3, z);

endmodule