module TopModule (
  input clk,
  input w,
  input R,
  input E,
  input L,
  output reg Q
);
  reg D;
  
  // Multiplexer to choose between input w and current Q
  assign D = E ? w : Q;
  
  // Multiplexer to choose between D and input R based on L
  always @(*)
    if (L)
      D <= R;
  
  // D flip-flop for storing the current value
  always @(posedge clk)
    Q <= D;
  
endmodule