module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q = 1'b0 // Initialize Q to 0
);

  wire mux_out;

  assign mux_out = L ? r_in : q_in;

  always @(posedge clk) begin
    Q <= mux_out;
  end

endmodule