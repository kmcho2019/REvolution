module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

  reg [31:0] in_d;

  always @(posedge clk) begin
    if (reset) begin
      out <= 32'b0;
      in_d <= 32'b0;
    end else begin
      in_d <= in;
      // Detect falling edge from 1 to 0 for each bit and set out bit
      out <= out | (in_d & ~in);
    end
  end

endmodule