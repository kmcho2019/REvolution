module TopModule(y, w, Y1);
  input [2:0] y;
  input w;
  output Y1;

  wire Y1_next;

  // Next-state logic for y[1]
  assign Y1_next = ((y == 3'b101 && w == 1'b0) || 
                   (y == 3'b101 && w == 1'b1) || 
                   (y == 3'b100 && w == 1'b0) || 
                   (y == 3'b100 && w == 1'b1) || 
                   (y == 3'b011 && w == 1'b1) || 
                   (y == 3'b010 && w == 1'b1) || 
                   (y == 3'b001 && w == 1'b1));

  assign Y1 = y[1];

endmodule