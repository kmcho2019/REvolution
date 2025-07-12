module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        // Transitions where y[1] becomes 1
        ({y, w} == 4'b0000) ? 1'b0 :  // A -> B (001)
        ({y, w} == 4'b0001) ? 1'b0 :  // A -> A (000)
        ({y, w} == 4'b0010) ? 1'b1 :  // B -> C (010)
        ({y, w} == 4'b0011) ? 1'b1 :  // B -> D (011)
        ({y, w} == 4'b0100) ? 1'b1 :  // C -> E (110)
        ({y, w} == 4'b0101) ? 1'b1 :  // C -> D (011)
        ({y, w} == 4'b0110) ? 1'b1 :  // D -> F (111)
        ({y, w} == 4'b0111) ? 1'b0 :  // D -> A (000)
        ({y, w} == 4'b1100) ? 1'b1 :  // E -> E (110)
        ({y, w} == 4'b1101) ? 1'b1 :  // E -> D (011)
        ({y, w} == 4'b1110) ? 1'b1 :  // F -> C (010)
        ({y, w} == 4'b1111) ? 1'b1 :  // F -> D (011)
        1'b0;  // Shouldn't occur with complete FSM

endmodule