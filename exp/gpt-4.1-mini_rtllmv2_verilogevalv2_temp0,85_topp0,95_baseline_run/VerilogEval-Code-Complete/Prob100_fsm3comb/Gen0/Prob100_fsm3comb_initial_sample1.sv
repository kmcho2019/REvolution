module TopModule (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output out
);

  // Next state logic
  always @(*) begin
    case(state)
      2'b00: // A
        if (in == 0) next_state = 2'b00; // A
        else         next_state = 2'b01; // B
      2'b01: // B
        if (in == 0) next_state = 2'b10; // C
        else         next_state = 2'b01; // B
      2'b10: // C
        if (in == 0) next_state = 2'b00; // A
        else         next_state = 2'b11; // D
      2'b11: // D
        if (in == 0) next_state = 2'b10; // C
        else         next_state = 2'b01; // B
      default:
        next_state = 2'b00; // default to A
    endcase
  end

  // Output logic (Moore machine: output depends on current state only)
  assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule