module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);
  reg [31:0] previous_in;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out <= 32'h0;
      previous_in <= 32'h0;
    end 
    else begin
      previous_in <= in;

      for (integer i = 0; i < 32; i = i + 1) begin
        if (previous_in[i] && !in[i])
          out[i] <= 1;
      end
    end
  end
endmodule