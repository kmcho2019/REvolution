module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (y[2] & y[1]) | 
                      (y[2] & ~y[1] & w) | 
                      (~y[2] & y[1] & ~w) | 
                      (~y[2] & ~y[1] & ~y[0] & w) | 
                      (~y[2] & ~y[1] & y[0] & ~w);

    // Next-state logic (only for demonstration, not used in the module)
    // assign next_y = {next_y2, next_y1, next_y0};

endmodule