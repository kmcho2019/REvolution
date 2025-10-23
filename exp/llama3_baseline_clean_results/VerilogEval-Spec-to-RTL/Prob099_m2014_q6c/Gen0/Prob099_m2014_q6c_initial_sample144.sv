module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & w); // next state is B when current state is A and w is 1
assign Y3 = (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w) | 
            (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w) | 
            (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w) | 
            (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & ~w); // next state is D when current state is B or C or E or F and w is 1, or when current state is D and w is 0

endmodule