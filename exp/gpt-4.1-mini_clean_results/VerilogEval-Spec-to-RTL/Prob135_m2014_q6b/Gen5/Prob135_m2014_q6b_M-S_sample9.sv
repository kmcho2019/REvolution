module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Direct decode for states
    wire is_B = (y == 3'b001);
    wire is_C = (y == 3'b010);
    wire is_E = (y == 3'b100);
    wire is_F = (y == 3'b101);

    // next_y1 logic
    wire next_y1 = is_B | is_F | ((is_C | is_E) & w);

    assign Y1 = next_y1;

endmodule