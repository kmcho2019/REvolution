module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    wire [5:0] next_state;

    // Next state logic
    assign next_state[0] = (~w & y[0]) | (~w & y[3]);  // A or D->A
    assign next_state[1] = (w & y[0]);                  // A->B
    assign next_state[2] = (w & y[1]) | (w & y[5]);     // B->C or F->C
    assign next_state[3] = (~w & y[1]) | (~w & y[2]) |  // B->D or C->D or
                         (~w & y[4]) | (~w & y[5]);    // E->D or F->D
    assign next_state[4] = (w & y[2]);                  // C->E
    assign next_state[5] = (w & y[3]);                  // D->F

    // Output extraction
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule