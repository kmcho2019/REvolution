module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = (y[0] & w) | (y[3] & w);  // A stays or D→A when w=1
    assign Y3 = y[1] & ~w;                // B→C when w=0

endmodule