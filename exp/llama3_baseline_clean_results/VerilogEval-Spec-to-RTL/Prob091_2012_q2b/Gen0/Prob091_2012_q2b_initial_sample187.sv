module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic for Y1 (y[1])
    // Y1 is '1' in the next state if the current state is A and w is '1' (going to B),
    // or if the current state is B and w is '0' (staying in a state where y[1] could be '1'),
    // or if the current state is C and w is '0' (going to D),
    // or if the current state is D and w is '1' (going to F, but F does not have y[1] as '1', so this condition is not needed),
    // or if the current state is E and w is '0' (going to D).
    assign Y1 = (y[0] && w) ||  // A to B
               (y[1] && ~w) ||  // B stays in a state that could have y[1] as '1' if going to D
               (y[2] && ~w) ||  // C to D
               (y[4] && ~w);    // E to D

    // Next state logic for Y3 (y[3])
    // Y3 is '1' in the next state if the current state is B and w is '1' (going to C),
    // or if the current state is C and w is '1' (going to E),
    // or if the current state is D,
    // or if the current state is E and w is '1' (staying in E).
    assign Y3 = (y[1] && w) ||  // B to C
               (y[2] && w) ||  // C to E
               y[3] ||        // D
               (y[4] && w);   // E stays in E

endmodule