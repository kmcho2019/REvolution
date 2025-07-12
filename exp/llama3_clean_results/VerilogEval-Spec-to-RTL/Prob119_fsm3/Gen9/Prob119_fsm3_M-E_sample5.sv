module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define states using one-hot encoding
reg a, b, c, d;

// Combinational logic for next state
reg a_next, b_next, c_next, d_next;

always @(*) begin
  // State A transitions
  a_next = (areset &&!a) || (!in && a) || (in && b);

  // State B transitions
  b_next = (in && a) || (in && b) || (!in && d);

  // State C transitions
  c_next = (!in && b) || (!in && c);

  // State D transitions
  d_next = (in && c);
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
  if (areset) begin
    a <= 1'b1;
    b <= 1'b0;
    c <= 1'b0;
    d <= 1'b0;
  end else begin
    a <= a_next;
    b <= b_next;
    c <= c_next;
    d <= d_next;
  end
end

// Output logic
assign out = d;

endmodule