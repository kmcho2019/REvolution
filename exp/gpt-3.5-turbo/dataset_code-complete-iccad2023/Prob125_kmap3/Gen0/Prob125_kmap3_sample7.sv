module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

// Simplified logic based on the grouped 1s in the Karnaugh map
always @* begin
  if (c == 0 && d == 0) begin
    if (a == 0 && b == 1)
      out = 1;
    else
      out = 0;
  end
  else if(c == 0 && d == 1) begin
    if (b == 1)
      out = d;
    else
      out = 0;
  end
  else if (c == 1 && d == 1)
    out = 1;
  else
    out = 1; // for case c == 1 && d == 0
end

endmodule