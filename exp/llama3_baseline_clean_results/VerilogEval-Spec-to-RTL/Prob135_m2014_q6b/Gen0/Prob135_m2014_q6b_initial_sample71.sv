module TopModule(
  input [2:0] y,
  input w,
  output Y1
);

  // Directly assign y[1] to Y1 since it's the current state's y[1]
  assign Y1 = y[1];

  // Next state logic for y[1]
  wire next_y1;
  always @(*) begin
    case (y)
      3'b000: next_y1 = w; // A (0) --0--> B, A (0) --1--> A
      3'b001: next_y1 = w; // B (0) --0--> C, B (0) --1--> D
      3'b010: next_y1 = w; // C (0) --0--> E, C (0) --1--> D
      3'b011: next_y1 = ~w; // D (0) --0--> F, D (0) --1--> A
      3'b100: next_y1 = w; // E (1) --0--> E, E (1) --1--> D
      3'b101: next_y1 = ~w; // F (1) --0--> C, F (1) --1--> D
      default: next_y1 = 1'bx;
    endcase
  end

endmodule