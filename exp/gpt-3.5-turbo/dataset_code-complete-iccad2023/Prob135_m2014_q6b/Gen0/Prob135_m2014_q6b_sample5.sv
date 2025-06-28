module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

always @ (*)
begin
  case(y[2])
    3'b000: Y2 = w ? 3'b011 : 3'b000;
    3'b001: Y2 = w ? 3'b100 : 3'b101;
    3'b010: Y2 = w ? 3'b101 : 3'b100;
    3'b011: Y2 = w ? 3'b110 : 3'b000;
    3'b100: Y2 = w ? 3'b100 : 3'b101;
    3'b101: Y2 = w ? 3'b100 : 3'b101;
    default: Y2 = 3'b000;
  endcase
end

endmodule