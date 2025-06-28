module TopModule (
  input clk,
  input x,
  output reg z
);

reg dff_x, dff_and, dff_or;

// XOR gate
always @*
begin
  dff_x = x ^ dff_x;
end

// AND gate
always @*
begin
  dff_and = ~(x & ~dff_and);
end

// OR gate
always @*
begin
  dff_or = ~(~x | dff_or);
end

// Output generation based on D flip-flop outputs
always @*
begin
  z = ~(dff_x | dff_and | dff_or);
end

endmodule