module TopModule (
  input clk,
  input resetn,
  input in,
  output reg out
);

reg [3:0] d_ff;

always @(posedge clk or negedge resetn)
begin
  if (~resetn) begin
    d_ff <= 4'b0000;
  end
  else begin
    d_ff <= {in, d_ff[3:1]};
  end
end

assign out = d_ff[0];

endmodule