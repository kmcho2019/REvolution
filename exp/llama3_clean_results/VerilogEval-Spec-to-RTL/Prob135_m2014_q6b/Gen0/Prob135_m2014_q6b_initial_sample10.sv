module TopModule(y, w, Y1);
  input [2:0] y;
  input w;
  output Y1;

  assign Y1 = y[1];

  // Next-state logic for y[1]
  // y[1] is 1 in states B (001), D (011, 111), and E (100)
  // We use a single equation to compute the next-state value of y[1]
  // based on the current state (y) and the input w
  wire next_y1;
  assign next_y1 = (y == 3'b000 && w) ||  // A (0) --1--> A, y[1] = 0
                   (y == 3'b000 && ~w) ||  // A (0) --0--> B, y[1] = 1
                   (y == 3'b001 && ~w) ||  // B (0) --0--> C, y[1] = 0
                   (y == 3'b001 && w) ||   // B (0) --1--> D, y[1] = 1
                   (y == 3'b010 && w) ||   // C (0) --1--> D, y[1] = 1
                   (y == 3'b011 && ~w) ||  // D (0) --0--> F, y[1] = 0
                   (y == 3'b011 && w) ||   // D (0) --1--> A, y[1] = 0
                   (y == 3'b100 && w);     // E (1) --1--> D, y[1] = 1
endmodule