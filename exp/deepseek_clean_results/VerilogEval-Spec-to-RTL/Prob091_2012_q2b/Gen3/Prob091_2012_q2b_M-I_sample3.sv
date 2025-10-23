module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (B) - only from A when w=1
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (D) - from B,C,E,F when w=0
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule