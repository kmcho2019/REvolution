module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Implement next state logic for Y1 (y[1])
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0]) & w;

// Implement next state logic for Y3 (y[3])
assign Y3 = ((~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]) | 
             (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0]) | 
             (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) | 
             (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0])) & ~w;

endmodule