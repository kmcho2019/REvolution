module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    // Correct and simplified next-state logic for y[1]
    wire next_y1 = ((y == 3'b001) |  // State B
                   (y == 3'b010) |  // State C
                   (y == 3'b100) |  // State E
                   (y == 3'b101))   // State F
                  & w;              // Transition to D (011) when w=1

endmodule