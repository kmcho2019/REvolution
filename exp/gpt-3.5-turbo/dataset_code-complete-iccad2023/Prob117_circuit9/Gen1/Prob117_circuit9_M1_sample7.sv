module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_prev;
reg [1:0] a_stable;

always @ (posedge clk) begin
  a_prev <= a; // Store previous value of 'a'
  if (a == 1'b1 && a_prev == 1'b1) begin // Check if 'a' has remained high continuously
    if (q < 3'd6) // Increment the counter from 0 to 6
      q <= q + 1;
  end
  else if (a == 1'b0 && a_prev == 1'b1) begin // Reset the counter only if 'a' transitions from high to low
    a_stable <= {a_stable[0], 1'b0}; // Shift in the new value of 'a' for comparison across clock cycles
    if (a_stable == 2'b00) // Check if 'a' has been low for 2 consecutive clock cycles
      q <= 3'b0; // Reset the counter to 0
  end
end

endmodule