module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg [2:0] shift_reg;
  
  always @(posedge clk) begin
    if (L) begin
      shift_reg <= r_in;
    end else begin
      shift_reg <= {shift_reg[1]^shift_reg[2], q_in, shift_reg[2]};
    end
  end

  assign Q = shift_reg[0];

endmodule