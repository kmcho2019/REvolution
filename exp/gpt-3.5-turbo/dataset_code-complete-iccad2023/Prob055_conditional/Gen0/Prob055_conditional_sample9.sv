module TopModule (
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  input [7:0] d,
  output reg [7:0] min
);

always @*
begin
  min = (a < b) ? a : b;
  min = (c < min) ? c : min;
  min = (d < min) ? d : min;
end

endmodule