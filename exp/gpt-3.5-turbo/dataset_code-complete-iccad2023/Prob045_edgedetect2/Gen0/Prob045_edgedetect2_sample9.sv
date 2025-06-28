module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] anyedge
);

reg [7:0] in_shifted;

always @(posedge clk) begin
  in_shifted <= in;
  anyedge <= (in ^ in_shifted) & ~in;
end

endmodule