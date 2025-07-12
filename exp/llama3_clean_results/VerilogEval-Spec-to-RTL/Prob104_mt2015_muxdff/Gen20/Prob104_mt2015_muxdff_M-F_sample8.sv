module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in; // Load r_in into Q when L is asserted
    end else begin
      Q <= Q ^ q_in; // Update Q with the XOR of its current value and q_in when L is not asserted
    end
  end

endmodule