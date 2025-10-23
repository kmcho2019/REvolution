module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Correct and optimized next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b100 & ~w) |        // Stay in E when w=0
        (w & (y == 3'b000 | y == 3'b001 | y == 3'b010 | y == 3'b011)) |  // Transition to D from A,B,C,D when w=1
        (~w & (y == 3'b001 | y == 3'b101));  // Transition to C from B or F when w=0

endmodule