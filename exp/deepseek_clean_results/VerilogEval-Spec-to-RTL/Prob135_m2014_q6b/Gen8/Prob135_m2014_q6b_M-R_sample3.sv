module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? (w ? 1'b0 : 1'b0) :  // A: 0->B(001), 1->A(000)
        (y == 3'b001) ? (w ? 1'b1 : 1'b0) :  // B: 0->C(010), 1->D(011)
        (y == 3'b010) ? (w ? 1'b1 : 1'b0) :  // C: 0->E(100), 1->D(011)
        (y == 3'b011) ? (w ? 1'b0 : 1'b0) :  // D: 0->F(101), 1->A(000)
        (y == 3'b100) ? (w ? 1'b1 : 1'b0) :  // E: 0->E(100), 1->D(011)
        (y == 3'b101) ? (w ? 1'b1 : 1'b1) :  // F: 0->C(010), 1->D(011)
        1'b0; // Should never reach here with complete FSM

endmodule