module TopModule (
  input [99:0] a,
  input [99:0] b,
  input sel,
  output reg [99:0] out
);
  
  always @ (a, b, sel)
  begin
    out = (sel == 1) ? b : a;
  end

endmodule