module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  wire mux_out;
  reg latch_enable;

  // Generate latch enable signal
  always @(posedge clk) begin
    latch_enable <= 1'b1;
  end
  always @(negedge clk) begin
    latch_enable <= 1'b0;
  end

  // 2:1 Multiplexer
  assign mux_out = L ? r_in : q_in;

  // Latch
  always @(*) begin
    if (latch_enable) begin
      Q <= mux_out;
    end
  end

endmodule