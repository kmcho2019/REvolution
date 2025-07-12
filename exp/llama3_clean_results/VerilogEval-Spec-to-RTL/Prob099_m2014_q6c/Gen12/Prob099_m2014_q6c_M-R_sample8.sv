module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next-state logic for Y2 (corresponding to state B)
assign Y2 = (~w & y[0]) | (~w & y[5]);

// Next-state logic for Y4 (corresponding to state D)
assign Y4 = (w & y[0]) | (~w & y[2]) | (w & y[2]) | (~w & y[3]) | (w & y[4]) | (w & y[5]);

// Output logic for Y1 and Y3, which directly correspond to the next-state logic of states A and C, respectively
assign Y1 = w & y[3];
assign Y3 = ~w & y[2];

endmodule