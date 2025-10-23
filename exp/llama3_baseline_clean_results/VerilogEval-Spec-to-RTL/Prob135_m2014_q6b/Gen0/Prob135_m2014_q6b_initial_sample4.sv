module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    // Next state logic for y[1]
    wire ns_y1;
    assign ns_y1 = (y == 3'b001) ? 1'b1 : // State B
                   (y == 3'b100) ? 1'b1 : // State D
                   (y == 3'b101 && w == 1'b1) ? 1'b1 : // State F and w = 1
                   (y == 3'b010 && w == 1'b1) ? 1'b1 : // State C and w = 1
                   (y == 3'b011 && w == 1'b1) ? 1'b1 : // State E and w = 1
                   1'b0;

endmodule