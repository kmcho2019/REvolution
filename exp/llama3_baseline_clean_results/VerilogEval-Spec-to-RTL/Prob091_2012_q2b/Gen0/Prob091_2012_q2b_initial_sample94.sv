module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

assign Y1 = y[0] & w;  // Next state is B when current state is A and w is '1'
assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w | y[3] & w;  // Next state is D when current state is B, C, E, or F and w is '0', or when current state is D and w is '1'

endmodule