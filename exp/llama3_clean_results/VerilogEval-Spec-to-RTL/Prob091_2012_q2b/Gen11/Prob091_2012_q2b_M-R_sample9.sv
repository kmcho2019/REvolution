module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);
    // Direct assignment for simplicity and efficiency
    assign Y1 = w & y[0];
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
endmodule