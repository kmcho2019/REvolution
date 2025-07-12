module TopModule (
  input  clk,
  input  L,
  input  q_in,
  input  r_in,
  output Q
);

  reg q;

  always @(posedge clk) begin
    if (L) begin
      q <= r_in;
    end else begin
      q <= q_in ^ r_in; // For the specific bit position, q_in represents the corresponding q[1] or q[0], and r_in is the input r at that position
    end
  end

  assign Q = q;

endmodule