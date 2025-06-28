module TopModule (
  input clk,
  input [7:0] d,
  output reg [7:0] q
);

reg [7:0] q_temp;

// Instantiate 8 D flip-flops in parallel
always @(posedge clk) begin
  q_temp <= d;
end

// Assign the outputs of the D flip-flops to the q output bus
always @(*) begin
  q = q_temp;
end

endmodule