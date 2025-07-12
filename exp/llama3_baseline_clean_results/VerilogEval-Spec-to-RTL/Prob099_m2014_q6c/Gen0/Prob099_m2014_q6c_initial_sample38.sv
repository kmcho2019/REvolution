module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

assign Y1 = y[3] & ~w; // Next state of y[0] is A when current state is D and w=0
assign Y3 = y[5] & ~w | y[1] & w; // Next state of y[2] is C when current state is F and w=0, or from B when w=1

endmodule