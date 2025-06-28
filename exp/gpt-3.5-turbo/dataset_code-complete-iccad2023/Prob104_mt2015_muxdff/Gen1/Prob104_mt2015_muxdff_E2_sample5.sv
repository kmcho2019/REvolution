module TopModule (
  input clk,
  input L,
  input r_in,
  output reg [2:0] Q
);

  reg [2:0] feedback_out;
  reg [2:0] mux_out;

  always @ (posedge clk) begin
    if (L) begin
      feedback_out <= Q;
    end else begin
      feedback_out <= {Q[1] ^ Q[2], Q[0], Q[2]};
    end
  end

  always @* begin
    if (L) begin
      mux_out = r_in;
    end else begin
      mux_out = feedback_out;
    end
  end

  assign Q = mux_out;

endmodule