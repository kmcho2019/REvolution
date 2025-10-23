module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[0] & w;          // Next state B when in A and w=1
    assign Y3 = ~(w | y[0] | y[3]); // Next state D when w=0 and not in A/D

endmodule