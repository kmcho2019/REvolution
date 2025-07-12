module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg prev_Q;

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end else begin
      Q <= q_in ^ prev_Q; // Incorporating XOR logic based on the problem description
    end
    prev_Q <= Q; // To maintain the previous state of Q for the XOR operation
  end

endmodule