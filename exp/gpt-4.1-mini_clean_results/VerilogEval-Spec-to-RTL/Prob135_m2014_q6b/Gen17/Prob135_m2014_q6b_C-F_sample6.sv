module TopModule(
    input  wire [2:0] y,  // Current state encoded in 3 bits: y2 y1 y0
    input  wire       w,  // Input signal influencing state transitions
    output wire       Y1  // Next state bit y[1]
);

    // Decode state bits for clarity and easier maintenance
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next-state logic for the middle bit of the state register (y[1])
    // Derived from FSM transitions and minimal Boolean expression:
    // Y1 = (y0 & ~y1) | (~y0 & w & (y1 | y2))
    assign Y1 = (y0 & ~y1) | (~y0 & w & (y1 | y2));

endmodule