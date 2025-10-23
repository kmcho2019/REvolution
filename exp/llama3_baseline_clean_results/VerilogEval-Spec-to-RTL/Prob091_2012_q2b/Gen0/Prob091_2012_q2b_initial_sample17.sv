module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 is high when the next state is B (from A with w=1 or from D with w=0) 
// or when the next state is E (from C with w=1 or from E with w=1)
assign Y1 = (y[0] && w) || (y[2] && w) || (y[4] && w);

// Y3 is high when the next state is D (from B with w=0, from C with w=0, 
// from E with w=0, or from D with w=0)
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w) || (y[3] && ~w);

endmodule