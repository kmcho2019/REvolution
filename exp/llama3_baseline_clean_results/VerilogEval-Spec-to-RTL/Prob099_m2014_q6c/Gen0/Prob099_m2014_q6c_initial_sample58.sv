module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Logic for Y1 (next state is A, considering y[0])
assign Y1 = (y[2] & ~w); // D and w=0 for next state A, corrected based on one-hot and transition logic

// Logic for Y3 (next state is C, considering y[2])
assign Y3 = (y[1] & ~w); // B and w=0 for next state C

endmodule