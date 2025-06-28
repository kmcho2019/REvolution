module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

// Y2 logic equations based on state transitions
assign Y2 = 
  (y[1] & w)  | // A -> A (w=1)
  (y[2] & ~w) | // B -> B (w=0)
  (y[3] & ~w) | // C -> C (w=0)
  (y[4] & ~w) | // D -> D (w=0)
  (y[5] & w)  | // E -> D (w=1)
  (y[6] & ~w);  // F -> C (w=0)

// Y4 logic equations based on state transitions
assign Y4 =
  (y[1] & ~w) | // A -> A (w=0)
  (y[2] & ~w) | // B -> C (w=0)
  (y[3] & ~w) | // C -> E (w=0)
  (y[4] & ~w) | // D -> F (w=0)
  (y[5] & w)  | // E -> D (w=1)
  (y[6] & w);   // F -> D (w=1)

endmodule