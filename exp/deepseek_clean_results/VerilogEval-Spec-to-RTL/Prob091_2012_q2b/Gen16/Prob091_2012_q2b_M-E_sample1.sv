module TopModule (
    input [5:0] y,  // One-hot encoded state
    input w,        // State machine input
    output Y1,      // Next state for y[1] (B)
    output Y3       // Next state for y[3] (D)
);

    // Transition masks for each output
    // Bit positions correspond to y[5:0]
    parameter [5:0] Y1_MASK = 6'b000001; // Only A (y[0]) can transition to B
    parameter [5:0] Y3_MASK = 6'b010110; // B(1), C(2), E(4), F(5) can transition to D

    // Intermediate signals
    wire y1_candidate, y3_candidate;
    
    // Pattern matching: Check if current state matches any transition source
    assign y1_candidate = |(y & Y1_MASK);
    assign y3_candidate = |(y & Y3_MASK);

    // Final outputs with input condition
    assign Y1 = y1_candidate & w;        // Y1 active when in A and w=1
    assign Y3 = y3_candidate & ~w;       // Y3 active when in B/C/E/F and w=0

    /* State Transition Rules:
       Y1 (B) transitions:
       - A → B when w=1 (mask 000001)
       
       Y3 (D) transitions:
       - B → D when w=0 (mask 000010)
       - C → D when w=0 (mask 000100)
       - E → D when w=0 (mask 010000)
       - F → D when w=0 (mask 100000)
    */
endmodule