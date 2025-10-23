module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Precompute common terms
    wire not_w = ~w;
    wire not_y0_or_y3 = ~(y[0] | y[3]);

    assign Y1 = y[0] & w;  // Direct implementation remains optimal
    assign Y3 = not_w & not_y0_or_y3;  // Uses precomputed terms

endmodule