module TopModule (
  input clk,
  input d,
  input ar,
  output reg q
);

always @(posedge clk or posedge ar)
begin
  if (ar)
    q <= 0; // Asynchronous reset active
  else
    q <= d; // Positive edge triggered
end

endmodule