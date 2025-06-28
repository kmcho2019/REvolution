module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_prev;
reg q_rising;
reg q_falling;

always @(posedge clk) begin
  // Store the previous output for comparison
  q_prev <= q;
  
  // Create the rising edge (clk) trigger
  q_rising <= (clk & ~q_prev) ? d : q_prev;
  
  // Create the falling edge (~clk) trigger
  q_falling <= (~clk & q_rising) ? d : q_rising;
  
  // Output the result
  q <= q_falling;
end

endmodule