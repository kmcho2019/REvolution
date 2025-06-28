module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);
  
  reg [31:0] in_delayed;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      in_delayed <= 32'b0;
      out <= 32'b0;
    end else begin
      in_delayed <= in_delayed; // Delayed input from previous cycle
      out <= (in_delayed ^ in) & ~in; // XOR operation to detect 1 to 0 transition
    end
  end

endmodule