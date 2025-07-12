module TopModule (
    input  [2:0] y,  // Current state encoding: A=000, B=001, C=010, D=011, E=100, F=101
    input        w,
    output       Y1
);

    // Extract bits of current state for readability
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Combinational next-state logic for y[1] based on current state and input w
    // From FSM transitions:
    // y1_next = (~y2 & ~y1 & y0)             // from B(001) to C(010) or D(011)
    //         | (~y2 & y1 & ~y0 & w)        // from C(010) to D(011)
    //         | (y2 & ~y1 & (~y0 | y0)) & w_or_0
    //         | (y2 & ~y1 & y0); // split into terms as per simplification below

    // Simplify terms:
    // y1_next = (~y2 & ~y1 & y0)                     // states B with w=0 or 1
    //         | (~y2 & y1 & ~y0 & w)                  // state C with w=1
    //         | (y2 & ~y1 & ~y0 & w)                  // state E with w=1
    //         | (y2 & ~y1 & y0);                       // state F, both w=0 or w=1

    assign Y1 = y1;  // Output current y[1]

    wire y1_next;
    assign y1_next =
        (~y2 & ~y1 & y0) |
        (~y2 & y1 & ~y0 & w) |
        (y2 & ~y1 & ~y0 & w) |
        (y2 & ~y1 & y0);

    // The y1_next signal is internal; it's the combinational next-state bit y[1]
    // For completeness, if a register update was required, it would be:
    // always @(posedge clk or posedge reset) y[1] <= y1_next; 
    // but this is outside the current problem scope.

endmodule