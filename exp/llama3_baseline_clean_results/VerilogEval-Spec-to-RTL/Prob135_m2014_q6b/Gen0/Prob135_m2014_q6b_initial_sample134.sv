module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b000 && w) ? 0 : // A(1) -> A
                       (y == 3'b000 && ~w) ? 0 : // A(0) -> B
                       (y == 3'b001 && w) ? 0 : // B(1) -> B
                       (y == 3'b001 && ~w) ? 0 : // B(0) -> C
                       (y == 3'b010 && w) ? 1 : // C(1) -> D
                       (y == 3'b010 && ~w) ? 0 : // C(0) -> E
                       (y == 3'b011 && w) ? 1 : // D(1) -> A
                       (y == 3'b011 && ~w) ? 1 : // D(0) -> F
                       (y == 3'b100 && w) ? 1 : // E(1) -> D
                       (y == 3'b100 && ~w) ? 1 : // E(0) -> E
                       (y == 3'b101 && w) ? 1 : // F(1) -> D
                       (y == 3'b101 && ~w) ? 0; // F(0) -> C
endmodule