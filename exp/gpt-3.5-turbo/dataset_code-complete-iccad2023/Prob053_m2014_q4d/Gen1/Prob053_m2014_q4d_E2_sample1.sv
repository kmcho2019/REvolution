module TopModule (
    input clk,
    input in,
    output logic out
);

  logic xor_out;
  logic feedback;

  // D flip-flop triggered on positive edge of clock
  always_ff @(posedge clk) begin
    feedback <= out;
    out <= d_ff;
  end

  // 2-input XOR gate
  assign xor_out = in ^ feedback;

  // D flip-flop
  always_ff @(posedge clk) begin
    d_ff <= xor_out;
  end

endmodule