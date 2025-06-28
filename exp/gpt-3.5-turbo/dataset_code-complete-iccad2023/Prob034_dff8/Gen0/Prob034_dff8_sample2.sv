module TopModule (
  input clk,
  input [7:0] d,
  output reg [7:0] q
);

reg [7:0] q_temp;

always @ (posedge clk) begin
  for (int i=0; i<8; i=i+1) begin
    if (i == 0)
      q_temp[i] <= d[i];
    else
      q_temp[i] <= q_temp[i-1];
  end
end

assign q = q_temp;

endmodule