module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg last_clock;

// Edge detector triggered by rising edge of clock
always @(posedge clock) begin
  // Save the previous value of clock
  last_clock <= clock;

  // Determine the changes based on inputs a and last value of clock
  if (a == 1 && last_clock == 0) begin
    // Toggle p
    p <= ~p;
    // Set q to 0
    q <= 0;
  end else if (p == 1) begin
    // Set q based on the value of a
    q <= a;
  end
end

endmodule