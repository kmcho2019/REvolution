module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
    );

    assign Y1 = y[1];

    // next-state logic for y[1]
    wire y1_next;
    assign y1_next = (y[0] & ~y[1] & ~w) | (~y[0] & y[1] & ~w) | (~y[0] & ~y[1] & w) | (y[0] & y[1] & ~w);

endmodule