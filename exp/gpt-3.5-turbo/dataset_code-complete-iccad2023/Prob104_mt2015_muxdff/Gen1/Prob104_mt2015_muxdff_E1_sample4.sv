module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg [2:0] Q
);

  reg [2:0] D_ff_out;
  wire [2:0] mux_out;

  always @ (posedge clk) begin
    if (L) begin
      D_ff_out <= r_in;
    end else begin
      D_ff_out <= mux_out;
    end
  end

  assign mux_out = L ? r_in : q_in;

  assign Q = D_ff_out;

endmodule