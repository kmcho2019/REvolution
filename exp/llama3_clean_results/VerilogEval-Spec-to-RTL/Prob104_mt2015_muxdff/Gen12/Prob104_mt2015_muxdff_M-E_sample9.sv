module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  input xor_in,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end else begin
      if (xor_in == 1'b1) begin
        Q <= q_in ^ xor_in;
      end else begin
        Q <= q_in;
      end
    end
  end

endmodule