module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

  reg [31:0] in_prev;

  initial begin
    in_prev <= 32'b0;
  end

  always @(posedge clk) begin
    if (reset) begin
      out <= 32'b0;
    end
    else begin
      for (int i=0; i<32; i=i+1) begin
        if (in[i] && !in_prev[i]) begin
          out[i] <= 1;
        end
      end
      in_prev <= in;
    end
  end

endmodule