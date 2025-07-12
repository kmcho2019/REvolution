module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

always_comb begin
  case (amount)
    2'b00: q_reg = (load) ? data : (ena) ? (q_reg << 1) : q_reg;
    2'b01: q_reg = (load) ? data : (ena) ? (q_reg << 8) : q_reg;
    2'b10: q_reg = (load) ? data : (ena) ? ($signed(q_reg) >>> 1) : q_reg;
    2'b11: q_reg = (load) ? data : (ena) ? ($signed(q_reg) >>> 8) : q_reg;
    default: q_reg = q_reg;
  endcase
end

always @(posedge clk) begin
  q <= q_reg;
end

endmodule