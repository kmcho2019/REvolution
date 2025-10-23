module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using case statement
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? (w ? 1'b0 : 1'b0) :  // A: 0->A (0), 1->B (0) [but B is 001, y[1] is 0]
        (y == 3'b001) ? (w ? 1'b1 : 1'b0) :  // B: 0->C (0), 1->D (1)
        (y == 3'b010) ? (w ? 1'b1 : 1'b0) :  // C: 0->E (1), 1->D (1)
        (y == 3'b011) ? (w ? 1'b0 : 1'b1) :  // D: 0->F (1), 1->A (0)
        (y == 3'b100) ? (w ? 1'b1 : 1'b1) :  // E: 0->E (1), 1->D (1)
        (y == 3'b101) ? (w ? 1'b1 : 1'b0) :  // F: 0->C (0), 1->D (1)
        1'b0;  // default (shouldn't occur)

endmodule