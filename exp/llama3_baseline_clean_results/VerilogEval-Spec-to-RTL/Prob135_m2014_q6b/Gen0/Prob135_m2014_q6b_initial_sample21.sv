module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b001 && w) ||  // From B to D
                     (y == 3'b100 && w) ||  // From C to D
                     (y == 3'b001 && ~w) || // From B to C (y[1] becomes 1 in next state)
                     (y == 3'b100 && ~w);   // From C to E is not applicable, but from C to D is

    // The actual implementation of the next state logic for y[1] considering the given state machine
    // is simplified to just the conditions where y[1] needs to be 1 in the next state.
    assign next_y1 = (y[1:0] == 2'b01 && w) || (y[1:0] == 2'b10 && w) || (y[1:0] == 2'b01 && ~w);

endmodule