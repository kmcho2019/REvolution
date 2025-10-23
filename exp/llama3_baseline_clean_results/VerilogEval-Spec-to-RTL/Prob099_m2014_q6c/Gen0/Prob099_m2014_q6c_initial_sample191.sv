module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

assign Y1 = (~y[5] & ~y[4] & y[3] & ~w);  // Next state is A (000001) if current state is D and w is 0
assign Y3 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~w) | (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & w) | (y[5] & ~w);  // Next state is C (000100) if current state is B and w is 0, or next state is E (010000) if current state is C and w is 1, or next state is C if current state is F and w is 0

endmodule