module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    wire next_y1;

    assign next_y1 = (
        (y == 3'b000 && w == 1'b0) ? 1'b0 : // State A transitions
        (y == 3'b001 && w == 1'b0) ? 1'b1 : // State B transitions
        (y == 3'b010 && w == 1'b0) ? 1'b1 : // State C transitions
        (y == 3'b011 && w == 1'b0) ? 1'b1 : // State D transitions
        (y == 3'b100 && w == 1'b0) ? 1'b1 : // State E transitions
        (y == 3'b101 && w == 1'b0) ? 1'b1 : // State F transitions
        (y == 3'b000 && w == 1'b1) ? 1'b0 : // State A transitions
        (y == 3'b001 && w == 1'b1) ? 1'b1 : // State B transitions
        (y == 3'b010 && w == 1'b1) ? 1'b1 : // State C transitions
        (y == 3'b011 && w == 1'b1) ? 1'b0 : // State D transitions
        (y == 3'b100 && w == 1'b1) ? 1'b1 : // State E transitions
        (y == 3'b101 && w == 1'b1) ? 1'b1 : // State F transitions
        1'b0
    );

    assign Y1 = next_y1;

endmodule