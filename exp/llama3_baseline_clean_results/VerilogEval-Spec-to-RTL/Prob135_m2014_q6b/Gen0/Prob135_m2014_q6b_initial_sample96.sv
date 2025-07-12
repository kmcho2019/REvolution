module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire y1_next;
    assign y1_next = (y == 3'b000 && w == 1) ? 1'b0 : // A (0) --1--> A
                    (y == 3'b001 && w == 1) ? 1'b1 : // B (0) --1--> D
                    (y == 3'b010 && w == 1) ? 1'b1 : // C (0) --1--> D
                    (y == 3'b011 && w == 0) ? 1'b0 : // D (0) --0--> F
                    (y == 3'b011 && w == 1) ? 1'b0 : // D (0) --1--> A
                    (y == 3'b100 && w == 1) ? 1'b1 : // E (1) --1--> D
                    (y == 3'b101 && w == 1) ? 1'b1 : // F (1) --1--> D
                    y[1]; // Otherwise, stay in the same state

    // Note: The next-state logic for y[1] is implemented using a wire
    //       and assign statement. The actual implementation of the next-state
    //       logic may vary depending on the desired synthesis style.
endmodule