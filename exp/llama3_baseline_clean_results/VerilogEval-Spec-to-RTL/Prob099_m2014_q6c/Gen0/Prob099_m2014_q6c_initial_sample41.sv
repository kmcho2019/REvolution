module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// State A (000001) goes to state B (000010) when w is 0, and stays in state A when w is 1
// State F (100000) goes to state C (000100) when w is 0
// State D (001000) goes to state A (000001) when w is 1
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & ~w) | 
            (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | 
            (~y[5] & ~y[4] & y[3] & ~y[2] & y[1] & ~y[0] & w);

// State B (000010) goes to state C (000100) when w is 0
// State C (000100) goes to state E (010000) when w is 1
// State D (001000) goes to state F (100000) when w is 0
assign Y3 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & ~w) | 
            (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w) | 
            (~y[5] & ~y[4] & y[3] & ~y[2] & y[1] & ~y[0] & ~w);

endmodule