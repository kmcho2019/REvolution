module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @* begin
  case ({c, d, a, b})
    4'b0000: out = 1; // c'd'ab'
    4'b0001: out = 0; // c'd'ab
    4'b0010: out = 1; // c'dab
    4'b0011: out = 1; // c'dab'
    4'b0101: out = 0; // cda'b
    4'b1011: out = 0; // cdab'
    default: out = 1; // Assign don't care cases to 1
  endcase
end

endmodule