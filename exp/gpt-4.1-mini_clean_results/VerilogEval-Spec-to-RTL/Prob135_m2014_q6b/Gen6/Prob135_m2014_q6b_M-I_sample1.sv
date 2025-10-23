module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // y encoding: A=000, B=001, C=010, D=011, E=100, F=101
    // Next y[1] from FSM transitions:
    // For B(001): next y[1] = 1 (B=001)
    // For C(010): next y[1] = w (C=010)
    // For E(100): next y[1] = w (E=100)
    // For F(101): next y[1] = 1 (F=101)
    // For other states, next y[1] = 0

    // Minimized logic for next y[1]:
    // next_y1 = (~y[2] & ~y[1] & y[0])        // B
    //         | (~y[2] & y[1] & ~y[0] & w)   // C & w
    //         | (y[2] & ~y[1] & ~y[0] & w)   // E & w
    //         | (y[2] & ~y[1] & y[0]);       // F

    // Combine terms sharing common factors:
    // Group states with y[2]=0 and y[1]=0 and y[0]=1: B
    // States with y[1]=1 and ~y[0] and ~y[2], w: C
    // States with y[2]=1, y[1]=0, and (y[0]=0 or 1), w and no w: E and F

    // Direct minimized form without decoding wires:
    assign Y1 = ( (~y[2]) & (~y[1]) & y[0] )              // B
              | ( (~y[2]) & y[1] & (~y[0]) & w )          // C & w
              | ( y[2] & (~y[1]) & ( ( ~y[0] & w ) | y[0] ) );  // E & w or F

endmodule