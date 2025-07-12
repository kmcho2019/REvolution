module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  wire next_state;

  assign next_state = L ? r_in : (q_in ^ Q); // Considering the single-bit nature and chain structure

  always @(posedge clk) begin
    Q <= next_state;
  end

endmodule