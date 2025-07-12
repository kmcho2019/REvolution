module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Directly assign next-state signals based on simplified logic equations
assign Y1 = (~w && y[0]) || (w && y[1]);
assign Y3 = (~w && y[2]) || (w && y[4]);

endmodule