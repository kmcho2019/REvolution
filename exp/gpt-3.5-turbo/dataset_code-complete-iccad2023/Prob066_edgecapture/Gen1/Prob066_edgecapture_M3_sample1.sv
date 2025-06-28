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
      for (int i=0; i<32; i=i+1) begin
        if (prev_in[i] && !in[i]) begin
          out[i] <= 1;
        end
      end
    end
  end

endmodule