module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    wire next_y1;
    
    // Next state logic for y[1]
    assign next_y1 = (~y[2] & ~y[1] & ~y[0] & ~w) |  // A -> B
                    (~y[2] & ~y[1] &  y[0]) |       // B -> C/D
                    (~y[2] &  y[1] & ~y[0] & w) |   // C -> D
                    (~y[2] &  y[1] &  y[0] & w) |   // D -> A
                    ( y[2] & ~y[1] & ~y[0] & w) |   // E -> D
                    ( y[2] & ~y[1] &  y[0]);        // F -> C/D

endmodule