module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Correct and simplified next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (w & ~(y == 3'b000)) |  // Transition to D (except from A)
        (y == 3'b100 & ~w);     // Stay in E

endmodule