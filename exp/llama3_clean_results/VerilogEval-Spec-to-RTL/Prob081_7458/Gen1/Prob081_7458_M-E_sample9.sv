module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

wire and_gate1;
wire and_gate2;
wire and_gate3;
wire and_gate4;

assign and_gate1 = p1a & p1b & p1c;
assign and_gate2 = p1d & p1e & p1f;
assign and_gate3 = p2a & p2b;
assign and_gate4 = p2c & p2d;

assign p1y = and_gate1 | and_gate2;
assign p2y = and_gate3 | and_gate4;

endmodule