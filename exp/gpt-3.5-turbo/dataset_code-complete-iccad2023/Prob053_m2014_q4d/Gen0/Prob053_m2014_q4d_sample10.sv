module XOR_FF (
  input clk,
  input in,
  output reg out
);

  reg d;
  
  always @ (posedge clk) begin
    d <= in ^ out; // XOR gate using input 'in' and output 'out'
    out <= d; // Connect output of XOR gate to D flip-flop data input
  end

endmodule