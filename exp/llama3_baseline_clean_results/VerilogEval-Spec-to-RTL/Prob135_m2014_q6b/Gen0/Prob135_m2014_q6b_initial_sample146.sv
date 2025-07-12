module TopModule(
    input [2:0] y,  // current state
    input w,
    output Y1      // next-state output
);

// next-state logic for y[1]
assign Y1 = (y == 3'b000 && w == 1'b1) ? 1'b0 :
           (y == 3'b001 && w == 1'b1) ? 1'b0 :
           (y == 3'b000 && w == 1'b0) ? 1'b1 :
           (y == 3'b001 && w == 1'b0) ? 1'b1 :
           (y == 3'b010 && w == 1'b1) ? 1'b1 :
           (y == 3'b010 && w == 1'b0) ? 1'b1 :
           (y == 3'b011 && w == 1'b1) ? 1'b0 :
           (y == 3'b011 && w == 1'b0) ? 1'b1 :
           (y == 3'b100 && w == 1'b1) ? 1'b1 :
           (y == 3'b100 && w == 1'b0) ? 1'b0 :
           (y == 3'b101 && w == 1'b1) ? 1'b0 :
           (y == 3'b101 && w == 1'b0) ? 1'b1 :
           y[1];

endmodule