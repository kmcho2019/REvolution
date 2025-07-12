module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire y1_next;
    assign y1_next = (y == 3'b000 && w == 1) || (y == 3'b001 && w == 1) || 
                     (y == 3'b010 && w == 1) || (y == 3'b011 && w == 0) || 
                     (y == 3'b100 && w == 1) || (y == 3'b101 && w == 1);

    // Next-state logic for y[1] can be simplified to:
    assign y1_next = (y[2:0] != 3'b101 && (y[2:0] == 3'b000 || w == 1));

endmodule