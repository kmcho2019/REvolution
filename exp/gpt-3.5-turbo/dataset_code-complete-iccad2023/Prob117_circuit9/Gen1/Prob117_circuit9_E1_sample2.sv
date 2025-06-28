module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  if (q == 3'b111) begin
    q <= 3'b000; // Reset the counter if it reaches 7
  end else begin
    q <= q + 1; // Increment the counter by 1
  end
end

endmodule