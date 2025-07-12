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
      Q <= q_in ^ r_in; // Reflects the shift and XOR logic based on q_in and r_in connections
    end
  end

endmodule