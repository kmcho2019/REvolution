module dff_with_reset (
  input clk,
  input d,
  input reset,
  output reg q
);

always @(negedge clk or posedge reset)
begin
  if (reset)
    q <= 8'd34;
  else
    q <= d;
end

endmodule

module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

reg [7:0] q_temp;

always @(posedge clk)
begin
  if (reset)
    q_temp <= 8'd34;
  else
    q_temp <= d;
end

// Instantiate 8 D flip-flops with reset
genvar i;
generate
  for (i = 0; i < 8; i = i + 1) begin : INST
    dff_with_reset dff_inst (
      .clk(clk),
      .d(q_temp[i]),
      .reset(reset),
      .q(q[i])
    );
  end
endgenerate

endmodule