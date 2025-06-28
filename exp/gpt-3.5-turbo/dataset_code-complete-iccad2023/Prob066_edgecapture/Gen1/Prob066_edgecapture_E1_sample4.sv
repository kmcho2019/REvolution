module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);
  // Register to store the delayed input
  reg [31:0] delayed_in;

  always @(posedge clk) begin
    if (reset) begin
      out <= 32'b0;
      delayed_in <= 32'b0;
    end
    else begin
      // Detect falling edges by XORing the current input with the delayed input
      // A falling edge occurs when the previous input was 1 and the current input is 0
      out <= delayed_in & ~in;
      
      // Update the delayed input with the current input for the next cycle
      delayed_in <= in;
    end
  end
endmodule