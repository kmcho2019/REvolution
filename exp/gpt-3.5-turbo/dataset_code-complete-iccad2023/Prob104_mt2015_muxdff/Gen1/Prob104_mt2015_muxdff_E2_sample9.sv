module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg [2:0] Q
);

  reg [2:0] dff_reg;
  
  always @(posedge clk) begin
    if (L) begin
      dff_reg <= r_in;
    end else begin
      dff_reg <= {dff_reg[1] ^ dff_reg[2], dff_reg[0], dff_reg[2]};
    end
  end

  always @* begin
    Q = L ? r_in : dff_reg;
  end

endmodule