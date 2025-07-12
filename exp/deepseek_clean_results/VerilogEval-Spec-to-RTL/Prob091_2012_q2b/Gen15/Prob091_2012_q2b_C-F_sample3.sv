module TopModule (
    input [5:0] y,  // One-hot encoded state: 
                    // y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,        // State machine input
    output Y1,      // Next state for y[1] (state B)
    output Y3       // Next state for y[3] (state D)
);

    // Y1: Transition from A (y[0]) to B (y[1]) occurs only when w=1
    // Optimal implementation: single AND gate
    assign Y1 = y[0] & w;

    // Y3: State D is entered when:
    // - w=0 AND current state is not A or D
    // Optimal implementation using De Morgan's law: ~(w | y[0] | y[3])
    // Equivalent to original ~w & ~(y[0] | y[3]) but with fewer gates
    assign Y3 = ~(w | y[0] | y[3]);

    /* State Transition Logic Details:
       Current State | Input | Next State | Y1 | Y3
       --------------------------------------------
       A (y[0])      | 1     | B (y[1])   | 1  | 0
       A (y[0])      | 0     | A (y[0])   | 0  | 0
       B (y[1])      | 1     | C (y[2])   | 0  | 0
       B (y[1])      | 0     | D (y[3])   | 0  | 1
       C (y[2])      | 1     | E (y[4])   | 0  | 0
       C (y[2])      | 0     | D (y[3])   | 0  | 1
       D (y[3])      | 1     | F (y[5])   | 0  | 0
       D (y[3])      | 0     | A (y[0])   | 0  | 0
       E (y[4])      | 1     | E (y[4])   | 0  | 0
       E (y[4])      | 0     | D (y[3])   | 0  | 1
       F (y[5])      | 1     | C (y[2])   | 0  | 0
       F (y[5])      | 0     | D (y[3])   | 0  | 1

       Optimization Notes:
       - Y3 implemented as ~(w | y[0] | y[3]) for minimal gate count
       - Equivalent to ~w & ~(y[0] | y[3]) but uses only 1 OR and 1 NOT gate
    */
endmodule