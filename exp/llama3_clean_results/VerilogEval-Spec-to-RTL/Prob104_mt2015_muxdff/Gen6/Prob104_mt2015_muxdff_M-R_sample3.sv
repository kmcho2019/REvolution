module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  input xor_in,
  output reg Q
);

  reg internal_Q;

  // Combinational logic for XOR operation
  assign Q = L ? r_in : q_in ^ xor_in;

  // Sequential logic for flip-flop operation
  always @(posedge clk) begin
    internal_Q <= Q;
  end

  // Assign internal_Q to Q for correct sequential behavior
  assign Q = internal_Q;

endmodule