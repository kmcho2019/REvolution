module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  input next_state,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end else begin
      Q <= next_state;
    end
  end

endmodule