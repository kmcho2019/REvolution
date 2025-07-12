module TopModule (
    input  [2:0] y,  // current state
    input  w,
    output Y1       // output Y1 is y[1]
);

assign Y1 = y[1];

// next-state logic for y[1]
wire next_y1;
assign next_y1 = ((~y[2] & ~y[1] & ~y[0] & w) |  // A -> A
                  (~y[2] & y[1] & ~y[0] & w) |  // B -> D
                  (y[2] & ~y[1] & y[0] & w) |  // C -> D
                  (y[2] & y[1] & ~y[0]) |     // D -> A or D
                  (y[2] & y[1] & y[0]) |      // E -> D or E
                  (~y[2] & y[1] & y[0] & w));  // F -> D

endmodule