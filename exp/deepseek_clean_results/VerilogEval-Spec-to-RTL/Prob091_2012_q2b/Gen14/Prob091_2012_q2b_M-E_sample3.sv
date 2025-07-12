module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state computation (all bits)
    wire [5:0] next_state;
    
    // State transition matrix implementation
    assign next_state[0] = (~w & y[0]) | (~w & y[3]);  // Stay in A or transition from D
    assign next_state[1] = (w & y[0]);                 // A→B
    assign next_state[2] = (w & y[1]) | (w & y[5]);    // B→C or F→C
    assign next_state[3] = (~w & y[1]) | (~w & y[2]) | (~w & y[4]) | (~w & y[5]);  // B/C/E/F→D
    assign next_state[4] = (w & y[2]) | (w & y[4]);    // C→E or stay in E
    assign next_state[5] = (w & y[3]);                 // D→F

    // Extract required outputs
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule