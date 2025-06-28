module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_prev;

always @ (posedge clk) begin
  if (a == 1'b1 && a_prev == 1'b0) begin
    // Increment the counter when 'a' transitions from low to high
    if (q < 3'd6)
      q <= q + 1;
  end else if (a == 1'b0) begin
    // Hold the counter value when 'a' is low
    q <= q;
  end
  a_prev <= a; // Store the previous value of 'a'
end

initial begin
  a_prev <= a; // Initialize 'a_prev' with the initial value of 'a'
end

endmodule