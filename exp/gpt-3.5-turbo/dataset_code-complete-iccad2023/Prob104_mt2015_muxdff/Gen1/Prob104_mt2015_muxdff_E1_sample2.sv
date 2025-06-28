module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg [2:0] Q
);

  reg [2:0] q_reg;
  reg [2:0] q_mux;

  always @ (posedge clk) begin
    if (L) begin
      q_reg <= r_in;
    end else begin
      q_reg <= {q_reg[1] ^ q_reg[2], q_reg[0], q_reg[2]};
    end
    q_mux <= L ? r_in : q_in;
  end

  assign Q = q_mux;

endmodule