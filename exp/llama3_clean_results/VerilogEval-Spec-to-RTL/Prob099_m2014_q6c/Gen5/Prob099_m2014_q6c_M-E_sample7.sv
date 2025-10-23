module TopModule(y, w, Y1, Y2, Y3, Y4);
  input [5:0] y;
  input w;
  output Y1;
  output Y2;
  output Y3;
  output Y4;

  reg [5:0] next_state;

  always @(y, w) begin
    case (1'b1)
      y[0] & ~w: next_state = 6'b000010; // Transition from A to B
      y[0] & w: next_state = 6'b000001; // Stay in A
      y[1] & ~w: next_state = 6'b000100; // Transition from B to C
      y[1] & w: next_state = 6'b001000; // Transition from B to D
      y[2] & ~w: next_state = 6'b010000; // Transition from C to E
      y[2] & w: next_state = 6'b001000; // Transition from C to D
      y[3] & ~w: next_state = 6'b100000; // Transition from D to F
      y[3] & w: next_state = 6'b000001; // Transition from D to A
      y[4] & ~w: next_state = 6'b010000; // Stay in E
      y[4] & w: next_state = 6'b001000; // Transition from E to D
      y[5] & ~w: next_state = 6'b000100; // Transition from F to C
      y[5] & w: next_state = 6'b001000; // Transition from F to D
    endcase
  end

  assign Y1 = next_state[0];
  assign Y2 = next_state[1];
  assign Y3 = next_state[2];
  assign Y4 = next_state[3];

endmodule