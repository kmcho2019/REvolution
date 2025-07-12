module TopModule(
    input [5:0] y,  // Current state
    input w,        // Input signal
    output Y1,      // Output for y[1]
    output Y3       // Output for y[3]
);

// State assignments
wire is_A = y[0];  // 000001
wire is_B = y[1];  // 000010
wire is_C = y[2];  // 000100
wire is_D = y[3];  // 001000
wire is_E = y[4];  // 010000
wire is_F = y[5];  // 100000

// Expression for Y1 (input for y[1])
// Y1 is 1 when the next state is B or D
assign Y1 = (is_A & ~w) |  // From A to B on w=0
            (is_B & ~w) |  // From B to D on w=0
            (is_C & ~w) |  // From C to D on w=0
            (is_D & ~w) |  // From D to A on w=0, but since A doesn't have y[1]=1, this doesn't contribute
            (is_E & ~w) |  // From E to D on w=0
            (is_F & ~w);   // From F to D on w=0

// Expression for Y3 (input for y[3])
// Y3 is 1 when the next state is E
assign Y3 = (is_C & w);  // From C to E on w=1

endmodule