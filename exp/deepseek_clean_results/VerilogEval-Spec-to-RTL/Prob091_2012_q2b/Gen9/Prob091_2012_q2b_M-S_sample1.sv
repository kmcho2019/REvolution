module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = y[0] & w;  // A->B transition when w=1
assign Y3 = ~w & (y[1] | y[2] | y[5]);  // B/C/F->D when w=0

endmodule