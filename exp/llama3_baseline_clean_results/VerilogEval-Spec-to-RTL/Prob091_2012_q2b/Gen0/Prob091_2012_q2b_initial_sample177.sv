module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Next-state logic for Y1 (state B)
    assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & ~w) | 
                (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & ~w);

    // Next-state logic for Y3 (state D)
    assign Y3 = (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | 
                (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | 
                (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & w) | 
                (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & ~w) | 
                (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w);
endmodule