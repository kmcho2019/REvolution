module TopModule (
  input clk,
  input x,
  output reg z
);
  
  reg d_ff1, d_ff2, d_ff3;
  
  always @(posedge clk)
  begin
    d_ff1 <= x ^ d_ff1; // XOR gate input with the flip-flop output
    d_ff2 <= ~(x & d_ff2); // AND gate input with the complement of flip-flop output
    d_ff3 <= ~d_ff3; // OR gate input with the complement of flip-flop output
    z <= ~(d_ff1 | d_ff2 | d_ff3); // Output Z from NOR gate of flip-flop outputs
  end

endmodule