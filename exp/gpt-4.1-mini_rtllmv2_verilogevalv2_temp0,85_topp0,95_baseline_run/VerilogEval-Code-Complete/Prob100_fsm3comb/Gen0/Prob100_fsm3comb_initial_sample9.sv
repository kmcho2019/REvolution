module TopModule (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output out
);

  // Next state logic
  always @(*) begin
    case(state)
      2'b00: next_state = (in == 1'b0) ? 2'b00 : 2'b01; // A
      2'b01: next_state = (in == 1'b0) ? 2'b10 : 2'b01; // B
      2'b10: next_state = (in == 1'b0) ? 2'b00 : 2'b11; // C
      2'b11: next_state = (in == 1'b0) ? 2'b10 : 2'b01; // D
      default: next_state = 2'b00;
    endcase
  end

  // Output logic (Moore): output depends only on current state
  assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule