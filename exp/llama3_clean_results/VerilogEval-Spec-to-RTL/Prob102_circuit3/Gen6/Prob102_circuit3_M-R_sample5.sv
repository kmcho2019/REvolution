module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire s1, s2;

assign s1 = a | b;
assign s2 = c | d;

always @(a, b, c, d) begin
    q = s1 & s2;
end

endmodule