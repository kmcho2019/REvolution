module TopModule (
  input clk,
  input L,
  input [2:0] q_in,
  input [2:0] r_in,
  output reg [2:0] Q
);

  reg [2:0] mux_out;
  reg [2:0] ff_out;

  always @* begin
    if (L) begin
      mux_out = r_in;
    end else begin
      mux_out = {q_in[1] ^ q_in[2], q_in[0], q_in[2]};
    end
  end

  always @(posedge clk) begin
    ff_out <= mux_out;
  end

  assign Q = ff_out;

endmodule