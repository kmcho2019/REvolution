module TopModule (
  input clk,
  input in,
  output logic out
);

  logic d_ff;

  // D flip-flop triggered on positive edge of clock with XORed input
  always @(posedge clk) begin
    d_ff <= in ^ out; // using the output directly here
    out <= d_ff;
  end

endmodule