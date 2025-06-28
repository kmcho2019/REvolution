module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg q
);

always @* begin
  case({a, b, c, d})
    4'b0101:
    4'b1101:
    4'b1110:
    4'b1111: q = 1;
    default: q = 0;
  endcase
end

endmodule