module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[0] & w;  // Optimal from both examples
    assign Y3 = ~w & ~(y[0] | y[3]);  // Fused optimization

endmodule