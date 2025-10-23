module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? (w ? 1'b0 : 1'b0) :  // A: stays 0 for both transitions
        (y == 3'b001) ? (w ? 1'b1 : 1'b1) :  // B: becomes 1 for both transitions
        (y == 3'b010) ? (w ? 1'b1 : 1'b1) :  // C: stays 1 for both transitions
        (y == 3'b011) ? (w ? 1'b0 : 1'b1) :  // D: 0->A or 1->F
        (y == 3'b110) ? (w ? 1'b1 : 1'b1) :  // E: stays 1 for both transitions
        (y == 3'b111) ? (w ? 1'b1 : 1'b1) :  // F: stays 1 for both transitions
        1'b0;  // Shouldn't occur with complete FSM

endmodule