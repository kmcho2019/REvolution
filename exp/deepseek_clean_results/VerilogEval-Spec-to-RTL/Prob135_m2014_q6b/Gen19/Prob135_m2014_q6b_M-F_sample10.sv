module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Correct and complete next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        ((y == 3'b001 | y == 3'b010 | y == 3'b101) & w) |  // B/C/F with w=1 → D
        (y == 3'b011 & ~w) |                                // D with w=0 → F
        (y == 3'b100 & ~w);                                 // E with w=0 → stays E

endmodule