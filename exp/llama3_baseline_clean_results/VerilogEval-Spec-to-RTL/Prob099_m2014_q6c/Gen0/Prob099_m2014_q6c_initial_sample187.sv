module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// One-hot encoding signals for states B and D
wire Y2;
wire Y4;

// Deriving logic equations by inspection
assign Y2 = (y[0] & ~w) | (y[1] & w) | (y[5] & w) | (y[4] & w); // Next-state signal for B
assign Y4 = (y[1] & w) | (y[2] & w) | (y[3] & ~w) | (y[4] & w) | (y[5] & w); // Next-state signal for D

// Assigning outputs Y1 and Y3
assign Y1 = y[0]; // Output for state A
assign Y3 = y[2]; // Output for state C

endmodule