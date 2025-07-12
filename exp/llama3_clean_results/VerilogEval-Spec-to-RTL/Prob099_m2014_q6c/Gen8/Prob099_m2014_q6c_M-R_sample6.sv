module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// State A (y[0]) or State D (y[3]) with w = 0
assign Y1 = (y[0] & ~w) | (y[3] & ~w);

// State A (y[0]) with w = 1, or State E (y[4]) with w = 0
assign Y2 = (y[0] & w) | (y[4] & ~w);

// State B (y[1]) with w = 1, State C (y[2]) with w = 0, or State F (y[5]) with w = 0
assign Y3 = (y[1] & w) | (y[2] & ~w) | (y[5] & ~w);

// State B (y[1]) with w = 1, State C (y[2]) with w = 1, or State F (y[5]) with w = 1
assign Y4 = (y[1] & w) | (y[2] & w) | (y[5] & w);

endmodule