module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in; // Load from r_in when L is high
    end else begin
      Q <= q_in; // When L is low, use q_in as it will be connected to reflect the necessary operations
    end
  end

endmodule