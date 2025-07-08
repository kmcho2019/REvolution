module TopModule (
  input clk,
  input x,
  output z
);
  reg q1, q2, q3;  // Outputs of the three D flip-flops
  
  // Flip-flop 1: XOR gate driving its input
  always @(posedge clk) begin
    q1 <= x ^ q1;
  end
  
  // Flip-flop 2: AND gate with complemented output driving its input
  always @(posedge clk) begin
    q2 <= x & (~q2);
  end
  
  // Flip-flop 3: OR gate with complemented output driving its input
  always @(posedge clk) begin
    q3 <= x | (~q3);
  end
  
  // Final output is NOR of all flip-flop outputs
  assign z = ~(q1 | q2 | q3);
endmodule