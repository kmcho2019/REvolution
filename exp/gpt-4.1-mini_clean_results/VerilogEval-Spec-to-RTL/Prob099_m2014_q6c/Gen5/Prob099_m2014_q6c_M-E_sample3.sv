module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A,..., y[5]=F
    input        w,
    output       Y2,  // Next-state bit for B (y[1])
    output       Y4   // Next-state bit for D (y[3])
);

    // next_y represents next state one-hot vector
    wire [5:0] next_y;

    // State encoding for clarity
    // y[0] = A
    // y[1] = B
    // y[2] = C
    // y[3] = D
    // y[4] = E
    // y[5] = F

    // Define combinational next-state logic for each state:
    // A: if w=0 next is B; else A
    assign next_y[0] = y[0] & w;                  // Stay in A if w=1
    assign next_y[1] = y[0] & ~w;                 // Go to B if w=0

    // B: if w=0 next is C; else D
    assign next_y[2] = y[1] & ~w;                 // Go to C
    assign next_y[3] = y[1] & w;                  // Go to D

    // C: if w=0 next is E; else D
    assign next_y[4] = y[2] & ~w;                 // Go to E
    assign next_y[3] = next_y[3] | (y[2] & w);   // Go to D (OR with previous D)

    // D: if w=0 next is F; else A
    assign next_y[5] = y[3] & ~w;                 // Go to F
    assign next_y[0] = next_y[0] | (y[3] & w);   // Go to A (OR with previous A)

    // E: if w=0 stay E; else D
    assign next_y[4] = next_y[4] | (y[4] & ~w);  // Stay E (OR with prev E)
    assign next_y[3] = next_y[3] | (y[4] & w);   // Go to D (OR with prev D)

    // F: if w=0 next is C; else D
    assign next_y[2] = next_y[2] | (y[5] & ~w);  // Go to C (OR with prev C)
    assign next_y[3] = next_y[3] | (y[5] & w);   // Go to D (OR with prev D)

    // Outputs are bits for next state B (y[1]) and D (y[3])
    assign Y2 = next_y[1];
    assign Y4 = next_y[3];

endmodule