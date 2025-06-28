module TopModule (
  input clk,
  input in,
  output logic out
);

  logic d_ff, next_state;

  // D flip-flop to store the current state
  always_ff @(posedge clk)
    d_ff <= next_state;

  // One-bit register to store the next state
  always_comb begin
    next_state = d_ff ^ in;
  end

  assign out = d_ff;

endmodule