module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    // Simplified next-state logic for y[1]
    assign next_y1 = ~((y == 3'b000) |               // State A
                     ((y == 3'b001) & ~w) |          // State B with w=0
                     (y == 3'b011));                 // State D

endmodule