module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    wire next_y1;
    
    // Simplified Boolean expression for next y[1]
    assign next_y1 = (y == 3'b001) |                 // From state B
                    ((y == 3'b010 | y == 3'b100) & w) | // From C/E when w=1
                    (y == 3'b101);                   // From state F

endmodule