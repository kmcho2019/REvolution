module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Derive next state for y[1] (Y1) based on current state and input w
  always @*
  begin
    case(y)
      6'b000001: Y1 = w; // A -> B
      6'b000010: Y1 = ~w; // B -> A
      6'b000100: Y1 = 1'b0; // C -> D
      6'b001000: Y1 = 1'b1; // D -> F
      6'b010000: Y1 = w; // E -> E
      6'b100000: Y1 = ~w; // F -> D
      default: Y1 = 1'b0; // Default to 0 for unknown states
    endcase
  end

  // Derive next state for y[3] (Y3) based on current state and input w
  always @*
  begin
    case(y)
      6'b000001: Y3 = 1'b0; // A -> D
      6'b000010: Y3 = 1'b0; // B -> D
      6'b000100: Y3 = w; // C -> E
      6'b001000: Y3 = 1'b0; // D -> D
      6'b010000: Y3 = 1'b0; // E -> D
      6'b100000: Y3 = w; // F -> C
      default: Y3 = 1'b0; // Default to 0 for unknown states
    endcase
  end

endmodule