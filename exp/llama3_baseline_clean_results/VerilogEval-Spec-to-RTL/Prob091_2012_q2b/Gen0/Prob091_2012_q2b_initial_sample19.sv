module TopModule (
    input [5:0] y,  // current state
    input w,        // input signal
    output Y1,      // input of state flip-flop y[1]
    output Y3       // input of state flip-flop y[3]
);

    // Y1 should be 1 when the current state is A and the input 'w' is 1, 
    // or when the current state is B and the input 'w' is 0.
    assign Y1 = (y[0] && w) || (y[1] && ~w);

    // Y3 should be 1 when the current state is B and the input 'w' is 0, 
    // or when the current state is C and the input 'w' is 0, 
    // or when the current state is E and the input 'w' is 0, 
    // or when the current state is D and the input 'w' is 0.
    assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w) || (y[3] && ~w);

endmodule