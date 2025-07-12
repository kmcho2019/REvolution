module TopModule (
    input [5:0] y,  // One-hot encoded state
    input w,        // State machine input
    output Y1,      // Next state for y[1] (B)
    output Y3       // Next state for y[3] (D)
);

    // Y1 is only set when in state A (y[0]) and w is 1
    assign Y1 = y[0] & w;

    // Y3 is set when in states B, C, E, or F and w is 0
    wire in_transition_states;
    assign in_transition_states = y[1] | y[2] | y[4] | y[5];
    
    assign Y3 = in_transition_states & ~w;

    /* State Transition Explanation:
       Y1 (B next state):
       - Only set when current state is A (y[0]) and input w=1
       
       Y3 (D next state):
       - Set when current state is one of {B,C,E,F} (y[1],y[2],y[4],y[5])
         and input w=0
       - This covers all transitions to state D:
         B->D (w=0), C->D (w=0), E->D (w=0), F->D (w=0)
    */
endmodule