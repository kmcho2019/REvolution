module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Current y[1] is the output

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        ((y == 3'b001 && w) ||  // B->D
         (y == 3'b010 && w) ||  // C->D
         (y == 3'b100 && w) ||  // E->D
         (y == 3'b101 && w)) ? 1'b1 : 1'b0;  // F->D

endmodule