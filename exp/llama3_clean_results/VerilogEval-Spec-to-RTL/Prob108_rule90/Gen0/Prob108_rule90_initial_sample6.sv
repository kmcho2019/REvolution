module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else begin
    q_reg <= {q_reg[510:0] ^ q_reg[511:1]};
  end
end

assign q = q_reg;

endmodule