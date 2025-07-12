module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Logic for Y1 (state B's input)
    assign Y1 = (y[0] && w) || (y[3] && ~w);

    // Logic for Y3 (state C's input)
    assign Y3 = (y[1] && w) || (y[5] && w);

endmodule