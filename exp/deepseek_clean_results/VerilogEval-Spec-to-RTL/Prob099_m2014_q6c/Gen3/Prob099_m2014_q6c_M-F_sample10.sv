module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

    // Next state logic for Y2 (y[1])
    assign Y2 = y[0] & ~w;  // A -> B when w=0

    // Next state logic for Y4 (y[3])
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;  // B/C/E/F -> D when w=1

endmodule