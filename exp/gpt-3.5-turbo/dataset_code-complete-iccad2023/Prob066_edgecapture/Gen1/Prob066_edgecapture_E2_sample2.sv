module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

reg [31:0] in_delayed;

always @(posedge clk) begin
  in_delayed <= in; // Delay the input by one clock cycle
end

always @(*) begin
  for (int i=0; i<32; i=i+1) begin
    if (!reset) begin
      if (in_delayed[i] && !in[i]) begin
        out[i] <= 1; // Capture the falling edge event
      end
    end else begin
      out[i] <= 0; // Reset the output on active high reset
    end
  end
end

endmodule