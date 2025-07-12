module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is set when the next state is B (000010)
// This happens when the current state is A (000001) and w is 1
assign Y1 = y[0] && w;

// Y3 is set when the next state is D (001000)
// This happens in several cases:
// 1. Current state is B and w is 0 (transition from B to D on w=0)
// 2. Current state is C and w is 0 (transition from C to D on w=0)
// 3. Current state is D and w is 0 (transition from D to A on w=0, but since we're checking for D, it actually stays in D or goes to A, not directly relevant for Y3)
// 4. Current state is E and w is 0 (transition from E to D on w=0)
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w);

endmodule