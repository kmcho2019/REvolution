module TopModule (
  input wire clk,
  input wire in,
  output reg out
);

  reg d_ff;
  
  // D flip-flop triggered on positive edge of clock
  always @(posedge clk)
    d_ff <= xor(in, out);

  // 2-input XOR gate
  function logic xor;
    input a, b;
    begin
      xor = a ^ b;
    end
  endfunction

  assign out = d_ff;

endmodule