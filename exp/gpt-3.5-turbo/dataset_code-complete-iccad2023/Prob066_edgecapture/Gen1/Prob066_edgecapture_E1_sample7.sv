module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

  reg [31:0] in_prev;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out <= 32'd0;
      in_prev <= in;
    end
    else begin
      // Use XOR to detect bit changes from 1 to 0
      wire [31:0] xor_result;
      xor_result = in ^ in_prev;
      
      // Update output based on XOR result
      for (int i = 0; i < 32; i = i + 1) begin
        if (xor_result[i])
          out[i] <= 1;
      end
      
      in_prev <= in;
    end
  end

endmodule