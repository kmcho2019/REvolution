module TopModule (
  input [3:0] a,
  input [3:0] b,
  input [3:0] c,
  input [3:0] d,
  input [3:0] e,
  output reg [3:0] q
);

always @* begin
  case (c)
    a: q <= b;
    c > a: q <= e;
    c < a: q <= d;
  endcase
end

endmodule