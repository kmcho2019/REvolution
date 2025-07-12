module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Next-state logic for y[1]
    wire y1_next;
    assign y1_next = ((y == 3'b011) & ~w) |  // D→F
                    ((y == 3'b100) & ~w) |  // E→E
                    ((y == 3'b101) & w);    // F→D

    // Output assignment
    assign Y1 = y[1];

endmodule