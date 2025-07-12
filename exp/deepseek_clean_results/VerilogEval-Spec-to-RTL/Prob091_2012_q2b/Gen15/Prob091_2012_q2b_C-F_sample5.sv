module TopModule (
    input [5:0] y,  // One-hot encoded state: 
                    // y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,        // State machine input
    output Y1,      // Next state for y[1] (state B)
    output Y3       // Next state for y[3] (state D)
);

    // Buffered inputs for better fanout control (from Example 1)
    wire [5:0] y_buf = y;
    wire w_buf = w;

    // Y1: Transition from A (y[0]) to B (y[1]) occurs when w=1 (from both examples)
    assign Y1 = y_buf[0] & w_buf;

    // Y3: State D is entered when:
    // - Not in A or D (~y[0] & ~y[3])
    // - And input w=0 (~w)
    // Implemented using De Morgan's equivalent for potential PPA benefits (from Example 1)
    assign Y3 = ~w_buf & ~y_buf[0] & ~y_buf[3];

    /* State Transition Logic Details (from Example 1):
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
    */
endmodule