module TopModule (
  input clk,
  input [7:0] d,
  output reg [7:0] q
);

reg [7:0] q_internal; // Internal signal to hold the values of the flip-flops

// Creating 8 D flip-flops
always @ (posedge clk) begin
  q_internal[0] <= d[0];
  q_internal[1] <= d[1];
  q_internal[2] <= d[2];
  q_internal[3] <= d[3];
  q_internal[4] <= d[4];
  q_internal[5] <= d[5];
  q_internal[6] <= d[6];
  q_internal[7] <= d[7];
end

// Assigning the internal flip-flop values to the output 'q'
assign q = q_internal;

endmodule