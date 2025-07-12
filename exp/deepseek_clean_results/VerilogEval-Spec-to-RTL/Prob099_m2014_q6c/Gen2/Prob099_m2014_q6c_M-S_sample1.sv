module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic for Y1 (y[1])
    assign Y1 = y[0] & ~w;  // A -> B when w=0

    // Next state logic for Y3 (y[3])
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;  // B/C/E/F -> D when w=1

endmodule