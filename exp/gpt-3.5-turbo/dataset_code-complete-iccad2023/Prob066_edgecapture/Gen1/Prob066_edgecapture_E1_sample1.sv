module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

  reg [31:0] temp_out;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out <= 32'd0;
      temp_out <= 32'd0;
    end
    else begin
      // Detect transition from 1 to 0 for each bit
      temp_out = (in & ~{in[31], in[31:1]});
      out <= temp_out;
    end
  end

endmodule