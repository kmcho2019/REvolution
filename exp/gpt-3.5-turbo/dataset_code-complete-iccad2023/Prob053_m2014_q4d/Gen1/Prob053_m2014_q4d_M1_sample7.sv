module TopModule (
  input clk,
  input in,
  output logic out
);
  
  logic xor_out;
  logic d_ff;
  logic d_ff_next;

  // D flip-flop triggered on positive edge of clock
  always @(posedge clk) begin
    d_ff <= d_ff_next;
    out <= d_ff;
  end

  // 2-input XOR gate
  assign xor_out = in ^ d_ff;

  // Register for storing next state of flip-flop
  always @* begin
    d_ff_next = xor_out;
  end

endmodule