module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Corrected next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? 1'b0 :  // State A -> next y[1] is 0
        (y == 3'b001) ? 1'b1 :  // State B -> next y[1] is 1
        (y == 3'b010) ? w :     // State C -> next y[1] follows w
        (y == 3'b011) ? 1'b0 :  // State D -> next y[1] is 0
        (y == 3'b100) ? 1'b1 :  // State E -> next y[1] is 1
        1'b1;                   // State F -> next y[1] is 1

endmodule