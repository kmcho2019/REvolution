module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    wire next_y1;
    assign next_y1 = 
        (~y[2] & ~y[1] & ~y[0] & ~w) ? 1'b0 : // A to B or A
        (~y[2] & ~y[1] & y[0] & ~w) ? 1'b0 : // B to C or D
        (~y[2] & y[1] & ~y[0] & ~w) ? 1'b1 : // C to E or D
        (~y[2] & y[1] & y[0] & ~w) ? 1'b0 : // D to F or A
        (y[2] & ~y[1] & ~y[0] & ~w) ? 1'b1 : // E to E or D
        (y[2] & y[1] & ~y[0] & ~w) ? 1'b0 : // F to C or D
        1'b0;

endmodule