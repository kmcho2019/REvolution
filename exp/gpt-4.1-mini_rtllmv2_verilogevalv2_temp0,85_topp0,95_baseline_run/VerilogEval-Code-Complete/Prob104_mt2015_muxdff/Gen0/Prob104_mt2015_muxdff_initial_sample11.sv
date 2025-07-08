module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  wire mux_out;

  // 2:1 MUX: select r_in if L=1 else q_in
  assign mux_out = L ? r_in : q_in;

  // D flip-flop: store mux_out on rising edge of clk
  always @(posedge clk) begin
    Q <= mux_out;
  end

endmodule