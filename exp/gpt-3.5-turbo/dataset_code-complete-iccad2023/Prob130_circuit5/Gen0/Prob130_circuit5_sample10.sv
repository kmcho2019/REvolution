module TopModule (
  input [3:0] a,
  input [3:0] b,
  input [3:0] c,
  input [3:0] d,
  input [3:0] e,
  output reg [3:0] q
);

always @* begin
  case (c[0])
    0: q = a ^ b;
    1: q = d ^ e;
    default: q = 4'b1111; // default value if c[0] is not 0 or 1
  endcase
end

endmodule