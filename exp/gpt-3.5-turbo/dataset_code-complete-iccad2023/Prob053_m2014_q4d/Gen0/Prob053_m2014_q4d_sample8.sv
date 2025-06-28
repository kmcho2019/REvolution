module TopModule (
  input clk,
  input in,
  output logic out
);
  
  logic xor_out;
  logic d_ff;

  // D flip-flop triggered on positive edge of clock
  always @(posedge clk) begin
    d_ff <= xor_out;
    out <= d_ff;
  end

  // 2-input XOR gate
  assign xor_out = in ^ d_ff;

endmodule