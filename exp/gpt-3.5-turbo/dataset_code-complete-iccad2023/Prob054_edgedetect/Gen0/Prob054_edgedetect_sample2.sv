module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

reg [7:0] prev_in;

always @ (posedge clk) begin
  for (int i = 0; i < 8; i = i + 1) begin
    if (in[i] && !prev_in[i])
      pedge[i] <= 1;
    else
      pedge[i] <= 0;
  end
  prev_in <= in;
end

endmodule