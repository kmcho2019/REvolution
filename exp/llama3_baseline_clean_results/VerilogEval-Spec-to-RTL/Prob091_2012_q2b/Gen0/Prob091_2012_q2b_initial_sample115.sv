module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = ~w & y[0];  // next state is B (000010) when current state is A (000001) and w is 0
assign Y3 = (~w & (y[1] | y[2] | y[4] | y[3] | y[5]));  // next state is D (001000) when current state is B or C or E or D or F and w is 0

endmodule