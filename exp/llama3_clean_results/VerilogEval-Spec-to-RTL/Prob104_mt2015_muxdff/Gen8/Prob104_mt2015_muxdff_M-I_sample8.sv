module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end else begin
      // Directly update Q based on q_in and the previous state of Q
      // Given the feedback, the operation should directly use Q and q_in
      // without needing an intermediate signal like Q_prev
      Q <= q_in ^ Q;
    end
  end

endmodule