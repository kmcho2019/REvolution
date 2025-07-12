module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);
    // Direct assignment for Y1: High when in state A and w is high
    assign Y1 = w & y[0];
    
    // Direct assignment for Y3: High when not in E or F and w is low, or in C, E, or F and w is low
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
endmodule