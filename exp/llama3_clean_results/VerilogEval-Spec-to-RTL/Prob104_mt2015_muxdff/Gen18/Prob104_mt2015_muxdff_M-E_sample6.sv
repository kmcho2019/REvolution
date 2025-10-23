module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg sel;
  reg new_val;

  always @(*) begin
    // Combinational logic to determine the new value
    new_val = L? r_in : q_in;
  end

  always @(posedge clk) begin
    // Update Q on every clock edge based on the combinational logic output
    Q <= new_val;
  end

endmodule