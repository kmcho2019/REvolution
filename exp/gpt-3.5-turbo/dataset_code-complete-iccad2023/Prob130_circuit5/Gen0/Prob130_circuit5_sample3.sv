module TopModule (
  input [3:0] a,
  input [3:0] b,
  input [3:0] c,
  input [3:0] d,
  input [3:0] e,
  output reg [3:0] q
);

always @*
begin
  if (c == 4'b0001)
    q = b;
  else
    q = 4'b1111; // f in binary 
end

endmodule