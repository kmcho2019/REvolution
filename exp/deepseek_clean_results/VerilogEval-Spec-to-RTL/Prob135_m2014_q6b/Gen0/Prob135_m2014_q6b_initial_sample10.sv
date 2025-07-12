module TopModule (
    input [2:0] y,
    input w,
    output Y1
);
    // Next-state logic for y[1]
    wire y1_next;
    assign y1_next = (~y[2] & y[1] & ~y[0] & ~w) |  // C (010) + w=0 -> E (100)
                    (~y[2] & y[1] & y[0] & ~w) |    // D (011) + w=0 -> F (101)
                    (y[2] & ~y[1] & ~y[0]) |        // E (100) stays or goes to D
                    (y[2] & ~y[1] & y[0]);          // F (101) goes to C or D

    // Output assignment
    assign Y1 = y[1];

    // Note: In a complete implementation, y1_next would be connected to a flip-flop
    // but the problem only asks for the next-state logic
endmodule