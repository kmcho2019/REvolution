module TopModule (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

reg [7:0] q_internal;

// 8 individual D flip-flops with asynchronous reset
always @(posedge clk or posedge areset)
begin
  if (areset) begin
    q_internal <= 8'b0;
  end
  else begin
    q_internal <= d;
  end
end

assign q = q_internal;

endmodule