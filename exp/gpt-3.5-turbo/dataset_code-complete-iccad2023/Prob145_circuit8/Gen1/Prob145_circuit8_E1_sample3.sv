module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg a_prev;

always @(posedge clock) begin
  // Detect rising edge of 'a'
  if (a && !a_prev) begin
    q <= ~q; // Toggle q on rising edge of 'a'
  end
  a_prev <= a;
  
  // Set p based on a
  if (a) begin
    p <= 1;
  end
  else begin
    p <= 0;
  end
end

endmodule