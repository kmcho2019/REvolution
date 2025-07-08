module TopModule (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output out
);

  // Output logic: only output=1 in state D (2'b11), else 0
  assign out = (state == 2'b11) ? 1'b1 : 1'b0;

  // Next state logic
  always @(*) begin
    case (state)
      2'b00: next_state = (in == 1'b0) ? 2'b00 : 2'b01; // A -> A if in=0, B if in=1
      2'b01: next_state = (in == 1'b0) ? 2'b10 : 2'b01; // B -> C if in=0, B if in=1
      2'b10: next_state = (in == 1'b0) ? 2'b00 : 2'b11; // C -> A if in=0, D if in=1
      2'b11: next_state = (in == 1'b0) ? 2'b10 : 2'b01; // D -> C if in=0, B if in=1
      default: next_state = 2'b00;
    endcase
  end

endmodule