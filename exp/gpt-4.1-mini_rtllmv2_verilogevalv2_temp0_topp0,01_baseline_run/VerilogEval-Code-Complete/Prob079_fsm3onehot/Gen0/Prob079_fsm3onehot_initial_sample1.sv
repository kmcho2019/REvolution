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
        next_state = (in == 1'b0) ? 4'b0001 : 4'b0010; // A or B
      4'b0010: // B
        next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // C or B
      4'b0100: // C
        next_state = (in == 1'b0) ? 4'b0001 : 4'b1000; // A or D
      4'b1000: // D
        next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // C or B
      default:
        next_state = 4'b0000; // default no state
    endcase
  end

  // Output logic: 1 only in state D
  assign out = state[3];

endmodule