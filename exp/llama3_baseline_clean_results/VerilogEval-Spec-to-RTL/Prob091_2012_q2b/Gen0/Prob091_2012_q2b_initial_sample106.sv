module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Expression for Y1 (input of state flip-flop y[1])
// Y1 is 1 when the next state is B or D
assign Y1 = (y[0] && ~w) || // A -> A (no change)
            (y[1] && ~w) || // B -> D
            (y[3] && w) ||  // D -> F
            (y[5] && ~w);  // F -> D

// Expression for Y3 (input of state flip-flop y[3])
// Y3 is 1 when the next state is C or E
assign Y3 = (y[1] && w) || // B -> C
            (y[2] && ~w) || // C -> D
            (y[4] && w);   // E -> E (no change)

endmodule