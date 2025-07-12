module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Explicit next state bits signals
    wire next_y0; // unused here
    wire next_y1;
    wire next_y2; // unused here

    // Next state logic for y[1] derived from given FSM transitions
    assign next_y1 = ( (~y[2]) & (~y[1]) & y[0] )             // B=001
                   | ( (~y[2]) & y[1] & (~y[0]) & w )         // C=010 & w
                   | ( y[2] & (~y[1]) & ( (~y[0] & w) | y[0] ) ); // E=100 & w or F=101

    // Output is simply the current y[1] bit as per specification
    assign Y1 = y[1];

endmodule