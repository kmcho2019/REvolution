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
      Q <= ~Q; // Toggle Q when L is not asserted, reflecting a simple update operation
    end
  end

endmodule