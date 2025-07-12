module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next state logic for Y1 (state A)
assign Y1 = (~w & y[0]) | (w & y[3]);

// Next state logic for Y3 (state C)
assign Y3 = (~w & y[1]) | (w & y[5]);

endmodule