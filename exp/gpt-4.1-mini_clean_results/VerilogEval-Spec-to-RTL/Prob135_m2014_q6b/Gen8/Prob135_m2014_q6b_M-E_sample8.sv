module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // From FSM and encoding:
    // next_y1 = y[1]'s next value depends on y and w as follows:
    // next_y1 = (~y2 & ~y1 & y0)       // B state -> next y1 = 1
    //         | (y2 & ~y1 & y0)        // F state -> next y1 = 1
    //         | (w & ((~y2 & y1 & ~y0)  // C state and w=1
    //                | (y2 & ~y1 & ~y0) )) // E state and w=1

    // Direct boolean expression without intermediate decoders:
    // next_y1 = ( ~y2 & ~y1 & y0 )
    //         | ( y2 & ~y1 & y0 )
    //         | ( w & ( (~y2 & y1 & ~y0) | (y2 & ~y1 & ~y0) ) );

    assign Y1 = (~y2 & ~y1 & y0)
             | ( y2 & ~y1 & y0 )
             | ( w & ( (~y2 & y1 & ~y0) | (y2 & ~y1 & ~y0) ) );

endmodule