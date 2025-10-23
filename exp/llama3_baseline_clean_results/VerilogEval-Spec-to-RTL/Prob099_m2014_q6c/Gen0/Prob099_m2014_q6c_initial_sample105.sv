module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 corresponds to state B
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & ~w) | 
            (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & ~w) | 
            (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w);

// Y3 corresponds to state D
assign Y3 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & w) | 
            (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & w) | 
            (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w) | 
            (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w);

endmodule