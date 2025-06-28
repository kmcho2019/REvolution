module TopModule (
  input clk,
  input L,
  input [2:0] q_in,
  input [2:0] r_in,
  output reg [2:0] Q
);

  reg [2:0] D_output;

  always @ (posedge clk) begin
    if (L) begin
      D_output <= r_in;
    end else begin
      D_output <= {Q[1] ^ Q[2], Q[0], Q[2]};
    end
  end

  always @(*) begin
    Q = L ? r_in : D_output;
  end

endmodule