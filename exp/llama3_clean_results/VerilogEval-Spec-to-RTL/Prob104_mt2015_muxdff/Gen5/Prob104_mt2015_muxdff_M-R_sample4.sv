module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  wire sel;

  assign sel = L? r_in : (q_in ^ Q);

  always @(posedge clk) begin
    Q <= sel;
  end

endmodule