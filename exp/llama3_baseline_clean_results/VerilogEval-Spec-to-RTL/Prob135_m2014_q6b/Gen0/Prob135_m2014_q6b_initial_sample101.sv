module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // y[1] is 1 for states C, D, E, F, and 0 for states A, B
    // next_y1 will be 1 if we are transitioning to one of these states
    // and 0 otherwise

    assign next_y1 = (y == 3'b000 && w == 1) || 
                     (y == 3'b001 && w == 1) || 
                     (y == 3'b001 && w == 0) || 
                     (y == 3'b010 && w == 1) || 
                     (y == 3'b011 && w == 0) || 
                     (y == 3'b011 && w == 1) || 
                     (y == 3'b101 && w == 1) || 
                     (y == 3'b100 && w == 1);

    assign Y1 = y[1];

endmodule