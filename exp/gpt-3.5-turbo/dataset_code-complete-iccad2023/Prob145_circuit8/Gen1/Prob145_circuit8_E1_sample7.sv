module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

// Internal signal to hold the value of 'a' when clock transitions from 1 to 0
reg a_prev;

always @(posedge clock) begin
  if (clock == 1'b1) begin
    a_prev <= a; // Capture the value of 'a' when clock is high
  end else begin
    // Update q with the previously captured 'a' value when clock goes low
    q <= a_prev;
  end
end

always @(posedge clock) begin
  // Update p with current value of 'a' only when clock goes high
  if (clock == 1'b1) begin
    p <= a;
  end
end

endmodule