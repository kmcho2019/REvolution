module EdgeDetection (
  input clk,
  input [31:0] in,
  output reg [31:0] rising_edge
);

reg [31:0] in_dly;

always @(posedge clk) begin
  in_dly <= in; // Delay the input by one clock cycle
  for (int i = 0; i < 32; i=i+1) begin
    if (in[i] == 1 && in_dly[i] == 0) begin
      rising_edge[i] <= 1; // Detect rising edge
    end
    else begin
      rising_edge[i] <= 0;
    end
  end
end

endmodule

module TopModule (
  input clk,
  input reset,
  input [31:0] in,
  output reg [31:0] out
);

reg [31:0] edge_detected;

EdgeDetection edge_detect (
  .clk(clk),
  .in(in),
  .rising_edge(edge_detected)
);

always @(posedge clk) begin
  if (reset) begin
    out <= 32'b0;
  end
  else begin
    out <= out | edge_detected; // Capture the edge condition
  end
end

endmodule