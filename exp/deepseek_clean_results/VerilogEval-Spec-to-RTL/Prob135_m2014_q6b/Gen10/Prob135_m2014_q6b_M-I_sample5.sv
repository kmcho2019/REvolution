module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Optimized next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        // States where y[1] is always 1 in next state: B(001) and F(101)
        (y == 3'b001 | y == 3'b101) ? 1'b1 :
        // States where y[1] depends on w: C(010) and E(100)
        (y == 3'b010 | y == 3'b100) ? w :
        // All other states (A(000), D(011)): y[1] is 0 in next state
        1'b0;

endmodule