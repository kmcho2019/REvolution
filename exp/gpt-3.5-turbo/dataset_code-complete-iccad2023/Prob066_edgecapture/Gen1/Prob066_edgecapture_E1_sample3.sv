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
      reg [31:0] changed_bits;
      
      changed_bits = prev_in ^ in; // XOR operation to identify changed bits
      out = changed_bits & ~in; // Masking to filter bits that changed from 1 to 0
      
      prev_in <= in;
    end
  end

endmodule