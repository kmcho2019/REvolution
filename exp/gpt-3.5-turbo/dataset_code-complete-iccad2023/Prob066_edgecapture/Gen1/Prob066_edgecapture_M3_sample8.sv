module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

  reg [31:0] prev_state;

  always @(posedge clk) begin
    if (reset) begin
      out <= 32'd0;
    end else begin
      for (int i=0; i<32; i=i+1) begin
        if (prev_state[i] && !in[i]) begin
          out[i] <= 1;
        end
      end
    end
    prev_state <= in;
  end

endmodule