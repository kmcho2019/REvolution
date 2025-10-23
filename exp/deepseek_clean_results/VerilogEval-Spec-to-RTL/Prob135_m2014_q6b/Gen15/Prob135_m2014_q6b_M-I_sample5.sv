module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    wire next_y1;
    
    // Correct and complete next-state logic for y[1]
    assign next_y1 = (~y[2] & ~y[1] & ~y[0] & ~w) |  // A->B
                    (~y[2] & ~y[1] & y[0] & w) |    // B->D
                    (~y[2] & y[1] & ~y[0] & w) |    // C->D
                    (~y[2] & y[1] & y[0] & ~w) |   // D->F
                    (y[2] & ~y[1] & ~y[0]) |       // E maintains or goes to D
                    (y[2] & ~y[1] & y[0] & w);     // F->D

endmodule