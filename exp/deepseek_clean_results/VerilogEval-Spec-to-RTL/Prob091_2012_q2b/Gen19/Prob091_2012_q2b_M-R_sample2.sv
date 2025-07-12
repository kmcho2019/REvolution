module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic for y[1] (B state)
    assign Y1 = y[0] & w;
    
    // Next state logic for y[3] (D state)
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule