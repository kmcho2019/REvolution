module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);
  
  reg [31:0] prev_in; // Register to store previous input

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      prev_in <= 32'b0; // Reset previous input register
      out <= 32'b0; // Reset output register
    end else begin
      prev_in <= in; // Update previous input register
      out <= (prev_in & (~in)); // Detect transition from 1 to 0 and capture in the output
    end
  end

endmodule