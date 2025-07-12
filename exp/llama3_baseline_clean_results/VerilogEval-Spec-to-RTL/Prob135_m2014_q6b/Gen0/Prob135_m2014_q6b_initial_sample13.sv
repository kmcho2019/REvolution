module TopModule(
  input  [2:0] y,
  input  w,
  output Y1
);

// Next-state logic for y[1]
assign Y1 = (y == 3'b000 && w) ||  // A (0) --1--> A
             (y == 3'b001 && w) ||  // B (0) --1--> D
             (y == 3'b100) ||      // E (1) --0--> E, E (1) --1--> D
             (y == 3'b101 && w);   // F (1) --1--> D

endmodule