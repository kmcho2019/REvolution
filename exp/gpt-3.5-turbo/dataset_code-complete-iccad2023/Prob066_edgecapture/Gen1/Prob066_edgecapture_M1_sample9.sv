module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

  reg [31:0] in_sync;

  always @(posedge clk) begin
    in_sync <= in;
    
    if (reset) begin
      out <= 32'd0;
    end
    else begin
      out <= out | (in_sync ^ (in_sync & ~out));
    end
  end

endmodule