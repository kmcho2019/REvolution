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
      Q <= q_in ^ Q; // This line directly updates Q based on q_in and the previous state of Q
    end
  end

endmodule