module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  // Next state logic
  always @(*) begin
    case (state)
      4'b0001: // A
        next_state = in ? 4'b0010 : 4'b0001; // A->A if in=0, A->B if in=1
      4'b0010: // B
        next_state = in ? 4'b0010 : 4'b0100; // B->C if in=0, B->B if in=1
      4'b0100: // C
        next_state = in ? 4'b1000 : 4'b0001; // C->A if in=0, C->D if in=1
      4'b1000: // D
        next_state = in ? 4'b0010 : 4'b0100; // D->C if in=0, D->B if in=1
      default:
        next_state = 4'b0001; // default to state A
    endcase
  end

  // Output logic (Moore output)
  assign out = state[3]; // Only state D (1000) outputs 1

endmodule