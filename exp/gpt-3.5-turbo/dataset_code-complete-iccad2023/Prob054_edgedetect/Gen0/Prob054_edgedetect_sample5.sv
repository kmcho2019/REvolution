module TopModule (
  input clk,
  input [7:0] in,
  output reg [7:0] pedge
);

reg [7:0] in_delayed; // Delayed input signal

always @(posedge clk) begin
  // Delay the input signal by one clock cycle
  in_delayed <= in;

  // Detect and set the output bit on the next clock cycle after a 0 to 1 transition
  for (int i = 0; i < 8; i = i + 1) begin
    if (in[i] && !in_delayed[i]) begin
      pedge[i] <= 1;
    end
  end
end

// Reset the output bits
always @(posedge clk) begin
  if (reset) begin
    pedge <= 8'b0;
  end
end

endmodule