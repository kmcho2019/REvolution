module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

reg [31:0] in_delayed;

always @(posedge clk) begin
  in_delayed <= in; // Delay the input by one clock cycle
  for (int i = 0; i < 32; i = i + 1) begin
    if (in[i] == 1 && in_delayed[i] == 0) begin
      out[i] <= 1; // Capture the change
    end else if (reset == 1) begin
      out[i] <= 0; // Reset the output
    end
  end
end

endmodule