module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

  reg [31:0] in_d; // delayed input for previous cycle

  always @(posedge clk) begin
    if (reset) begin
      out <= 32'b0;
      in_d <= 32'b0;
    end else begin
      // Detect 1->0 transition: previous bit was 1 and current bit is 0
      out <= out | (in_d & ~in);
      in_d <= in;
    end
  end

endmodule