module TopModule(y, w, Y1);
  input [2:0] y;
  input w;
  output Y1;

  assign Y1 = y[1];

  // Next-state logic for y[1]
  wire next_y1;
  assign next_y1 = (y == 3'b000 && w == 1'b0) ? 1'b0 :
                   (y == 3'b000 && w == 1'b1) ? 1'b0 :
                   (y == 3'b001 && w == 1'b0) ? 1'b0 :
                   (y == 3'b001 && w == 1'b1) ? 1'b0 :
                   (y == 3'b010 && w == 1'b0) ? 1'b1 :
                   (y == 3'b010 && w == 1'b1) ? 1'b1 :
                   (y == 3'b011 && w == 1'b0) ? 1'b1 :
                   (y == 3'b011 && w == 1'b1) ? 1'b0 :
                   (y == 3'b100 && w == 1'b0) ? 1'b1 :
                   (y == 3'b100 && w == 1'b1) ? 1'b1 :
                   (y == 3'b101 && w == 1'b0) ? 1'b0 :
                   (y == 3'b101 && w == 1'b1) ? 1'b1 : 1'bx;

  // The actual next-state logic will be used in a larger FSM
  // For demonstration purposes, we just display the calculated next_y1
  assign Y1 = next_y1;

endmodule