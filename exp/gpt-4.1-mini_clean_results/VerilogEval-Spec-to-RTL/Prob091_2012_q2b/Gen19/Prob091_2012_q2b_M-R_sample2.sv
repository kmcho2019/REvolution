module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Next state input for y[1] (state B): A (y[0]) -> B on w=1
    assign Y1 = y[0] & w;

    // Next state input for y[3] (state D):
    // D is reached from B (y[1]), C (y[2]), or F (y[5]) on w=0
    // So Y3 = ~w & (y[1] | y[2] | y[5])
    assign Y3 = (~w) & (y[1] | y[2] | y[5]);

endmodule