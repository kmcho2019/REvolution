module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

reg [31:0] prev_in;

always @* begin
  for (int i = 0; i < 32; i = i + 1) begin
    if (!reset && prev_in[i] && !in[i])
      out[i] <= 1;
    else
      out[i] <= 0;
  end
end

always @(posedge clk) begin
  prev_in <= in;
end

endmodule