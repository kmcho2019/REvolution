module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 remains optimal - only state A (y[0]) can transition to B (y[1]) when w=1
    assign Y1 = y[0] & w;

    // Optimized Y3 implementation:
    // States that transition to D (y[3]) when w=0:
    // B (y[1]), C (y[2]), E (y[4]), F (y[5])
    // Using one-hot property, we can implement this as:
    assign Y3 = ~w & (|{y[1], y[2], y[4], y[5]});

endmodule