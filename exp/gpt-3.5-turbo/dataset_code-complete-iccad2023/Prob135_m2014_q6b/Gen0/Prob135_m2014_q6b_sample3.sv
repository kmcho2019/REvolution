module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

  always @(*) begin
    case(y[2:1])
      2'b00: Y2 = (y[3] & !w) | (!y[3] & w); // Transition from state A to B or A
      2'b01: Y2 = (y[3] & !w) | (!y[3] & w); // Transition from state B to C or D
      2'b10: Y2 = (y[3] & !w) | (!y[3] & w); // Transition from state C to E or D
      2'b11: Y2 = (y[3] & !w) | (!y[3] & w); // Transition from state D to F or A
      default: Y2 = 1'b0;
    endcase
  end

endmodule