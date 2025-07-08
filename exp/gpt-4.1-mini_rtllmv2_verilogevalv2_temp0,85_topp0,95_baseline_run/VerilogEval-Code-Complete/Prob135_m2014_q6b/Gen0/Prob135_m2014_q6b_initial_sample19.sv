module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);
  always @(*) begin
    case (y)
      3'b000: // A
        Y2 = 0; // both w=0 or 1 lead to next y2=0
      3'b001: // B
        Y2 = 1; // w=0 or 1 lead to next states with y2=1
      3'b010: // C
        Y2 = (w == 0) ? 0 : 1;
      3'b011: // D
        Y2 = 0; // both w lead to next states with y2=0
      3'b100: // E
        Y2 = (w == 0) ? 0 : 1;
      3'b101: // F
        Y2 = 1; // both w lead to next states with y2=1
      default:
        Y2 = 0; // default safe value
    endcase
  end
endmodule