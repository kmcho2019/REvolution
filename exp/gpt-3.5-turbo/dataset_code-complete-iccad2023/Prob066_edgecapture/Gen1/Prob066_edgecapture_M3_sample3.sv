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
      prev_in <= {prev_in[30:0], in[31]}; // Shift previous input vector by one bit
      out <= (prev_in & ~in); // Capture the transition from 1 to 0
    end
  end

endmodule