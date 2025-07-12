module TopModule (
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Next-state signal Y2 corresponding to y[1]
assign Y2 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & ~w) | 
            (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | 
            (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & ~w);

// Next-state signal Y4 corresponding to y[3]
assign Y4 = (~y[5] & ~y[4] & y[3] & ~y[2] & y[1] & ~y[0] & w) | 
            (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w) | 
            (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w);

// Output Y1 corresponding to y[0]
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0]);

// Output Y3 corresponding to y[2]
assign Y3 = (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]);

endmodule