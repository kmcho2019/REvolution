module TopModule (
    input  [5:0] y,   // Current one-hot state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1,  // next_y[1]
    output       Y2,  // next_y[2]
    output       Y3,  // next_y[3]
    output       Y4   // next_y[4]
);

    // State encoding:
    // A = y[0]
    // B = y[1]
    // C = y[2]
    // D = y[3]
    // E = y[4]
    // F = y[5]

    // For each state and input w, define next states (per transitions):
    // From A (y[0]):
    //   w=0 -> B (Y1)
    //   w=1 -> A (y[0], no outputs here)
    //
    // From B (y[1]):
    //   w=0 -> C (Y2)
    //   w=1 -> D (Y3)
    //
    // From C (y[2]):
    //   w=0 -> E (Y4)
    //   w=1 -> D (Y3)
    //
    // From D (y[3]):
    //   w=0 -> F (y[5], no outputs)
    //   w=1 -> A (y[0], no outputs)
    //
    // From E (y[4]):
    //   w=0 -> E (Y4)
    //   w=1 -> D (Y3)
    //
    // From F (y[5]):
    //   w=0 -> C (Y2)
    //   w=1 -> D (Y3)

    // Compute next_y[1] (Y1): set when next state is B
    // Only from A with w=0
    assign Y1 = y[0] & (~w);

    // Compute next_y[2] (Y2): set when next state is C
    // From B (w=0) and F (w=0)
    assign Y2 = (y[1] & (~w)) | (y[5] & (~w));

    // Compute next_y[3] (Y3): set when next state is D
    // From B (w=1), C (w=1), E (w=1), F (w=1)
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

    // Compute next_y[4] (Y4): set when next state is E
    // From C (w=0), E (w=0)
    assign Y4 = (y[2] & (~w)) | (y[4] & (~w));

endmodule