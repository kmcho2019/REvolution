module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

always @(*) begin
  case (y)
    3'b000: // A
      if (w == 0)
        Y2 = 1'b0; // B: 001 -> y2=0
      else
        Y2 = 1'b0; // A: 000 -> y2=0
    3'b001: // B
      if (w == 0)
        Y2 = 1'b1; // C: 010 -> y2=1
      else
        Y2 = 1'b1; // D: 011 -> y2=1
    3'b010: // C
      if (w == 0)
        Y2 = 1'b0; // E: 100 -> y2=0
      else
        Y2 = 1'b1; // D: 011 -> y2=1
    3'b011: // D
      if (w == 0)
        Y2 = 1'b0; // F: 101 -> y2=0
      else
        Y2 = 1'b0; // A: 000 -> y2=0
    3'b100: // E
      if (w == 0)
        Y2 = 1'b0; // E: 100 -> y2=0
      else
        Y2 = 1'b1; // D: 011 -> y2=1
    3'b101: // F
      if (w == 0)
        Y2 = 1'b1; // C: 010 -> y2=1
      else
        Y2 = 1'b1; // D: 011 -> y2=1
    default: // default safe
      Y2 = 1'b0;
  endcase
end

endmodule