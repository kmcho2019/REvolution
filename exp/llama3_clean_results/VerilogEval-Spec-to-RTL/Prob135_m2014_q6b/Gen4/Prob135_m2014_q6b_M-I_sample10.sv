module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    wire next_y1;
    assign next_y1 = (w) ? (
        (y == 3'b000) ? 0 : // A to A
        (y == 3'b001) ? 1 : // B to D
        (y == 3'b010) ? 1 : // C to D
        (y == 3'b011) ? 0 : // D to A
        (y == 3'b100) ? 0 : // E to D
        (y == 3'b101) ? 0 : // F to D
        0
    ) : (
        (y == 3'b000) ? 0 : // A to B
        (y == 3'b001) ? 0 : // B to C
        (y == 3'b010) ? 0 : // C to E
        (y == 3'b011) ? 0 : // D to F
        (y == 3'b100) ? 0 : // E to E
        (y == 3'b101) ? 0 : // F to C
        0
    );
endmodule