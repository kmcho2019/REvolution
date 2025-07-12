module TopModule (
    input [5:0] y,  // One-hot state encoding: A(y[0]), B(y[1]), C(y[2]), D(y[3]), E(y[4]), F(y[5])
    input w,
    output Y1,
    output Y3
);

    // Input conditioning
    wire w_bar = ~w;

    // State masking for Y1 (only needs to consider transition from A to B)
    wire Y1_active = y[0];  // Only A state can activate Y1

    // State masking for Y3 (transitions from B, C, E, F to D)
    wire Y3_active = y[1] | y[2] | y[4] | y[5];  // States that can transition to D
    wire Y3_excluded = y[0] | y[3];              // States that never transition to D

    // Output logic
    assign Y1 = Y1_active & w;                   // A->B when w=1
    assign Y3 = Y3_active & w_bar & ~Y3_excluded; // To D when w=0 and not in excluded states

    /* State Transition Logic Explanation:
       Y1 Logic:
       - Only active when in state A (y[0]) and input w is high
       - Single AND gate implementation

       Y3 Logic:
       - Active when in states B,C,E,F (y[1],y[2],y[4],y[5])
       - Only when input w is low
       - Explicitly excludes states A and D where D cannot be next state
       - Implemented as (active_states & ~w & ~excluded_states)
    */
endmodule