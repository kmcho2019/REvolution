module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    // Simplified next-state logic for y[1]
    wire next_y1 = (~y[2] & ((y[1] & ~y[0] & w) | (~y[1] & y[0] & ~w))) |
                   (y[2] & (y[0] | ~w));

endmodule