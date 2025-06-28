module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);
  
  reg [31:0] prev_in;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      prev_in <= 32'b0;
      out <= 32'b0;
    end else begin
      prev_in <= in;
      // Perform XNOR operation to detect 1 to 0 transitions
      out <= (prev_in ^ in) & ~in;
    end
  end

endmodule