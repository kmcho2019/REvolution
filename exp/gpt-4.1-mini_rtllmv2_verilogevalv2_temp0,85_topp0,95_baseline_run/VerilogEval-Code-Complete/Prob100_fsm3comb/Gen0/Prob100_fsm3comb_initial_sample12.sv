module TopModule (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output out
);

  // Output logic: Moore output depends only on current state
  assign out = (state == 2'b11) ? 1'b1 : 1'b0;

  always @(*) begin
    case (state)
      2'b00: // A
        next_state = (in == 1'b0) ? 2'b00 : 2'b01; // A or B
      2'b01: // B
        next_state = (in == 1'b0) ? 2'b10 : 2'b01; // C or B
      2'b10: // C
        next_state = (in == 1'b0) ? 2'b00 : 2'b11; // A or D
      2'b11: // D
        next_state = (in == 1'b0) ? 2'b10 : 2'b01; // C or B
      default:
        next_state = 2'b00; // default to A on invalid state
    endcase
  end

endmodule