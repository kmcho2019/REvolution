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
      // Directly update Q based on q_in and the current state of Q
      // This assumes Q is used in a context where its update depends on q_in
      Q <= q_in;
    end
  end

endmodule