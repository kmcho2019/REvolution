module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  if (q == 3'd7 || (a == 1'b0 && q != 3'b0)) begin
    q <= 3'b0; // Reset counter to 0 when it reaches 7 or when a transitions from 1 to 0
  end else begin
    q <= q + 1; // Increment counter by 1 on every rising edge of clk
  end
end

endmodule