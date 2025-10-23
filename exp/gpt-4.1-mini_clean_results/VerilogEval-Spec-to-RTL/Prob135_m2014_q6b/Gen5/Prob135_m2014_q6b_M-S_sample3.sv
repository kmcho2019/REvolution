module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire B = (y == 3'b001);
    wire C = (y == 3'b010);
    wire E = (y == 3'b100);
    wire F = (y == 3'b101);

    wire next_y1 = B | F | ((C | E) & w);

    assign Y1 = next_y1;

endmodule