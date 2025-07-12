module TopModule (
    input [5:0] y,  // One-hot encoded state
    input w,        // State machine input
    output Y1,      // Next state for y[1] (B)
    output Y3       // Next state for y[3] (D)
);

    // Y1 is only set when current state is A (y[0]) and input is 1
    assign Y1 = y[0] & w;

    // Y3 is set when:
    // 1. Current state is B (y[1]) and input is 0, OR
    // 2. Current state is C (y[2]) and input is 0, OR
    // 3. Current state is E (y[4]) and input is 0, OR
    // 4. Current state is F (y[5]) and input is 0
    // Using parallel bit operations for efficient implementation
    assign Y3 = ~w & (|{y[1], y[2], y[4], y[5]});

    /* State Transition Logic Explanation:
       The implementation uses the following observations:
       - Y1 only depends on y[0] and w
       - Y3 can be computed by OR-ing all states that transition to D when w=0
       - The one-hot encoding ensures only one state bit is active at a time,
         so we don't need to worry about multiple active states
       - This approach minimizes logic depth while maintaining clarity
    */
endmodule