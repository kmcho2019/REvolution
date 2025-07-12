module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg q_int; // Internal signal to hold the value of Q

  // Update rule for q_int
  always @(posedge clk) begin
    if (L) begin
      q_int <= r_in; 
    end else begin
      q_int <= q_in; 
    end
  end

  // Continuous assignment to output Q
  assign Q = q_int;

endmodule