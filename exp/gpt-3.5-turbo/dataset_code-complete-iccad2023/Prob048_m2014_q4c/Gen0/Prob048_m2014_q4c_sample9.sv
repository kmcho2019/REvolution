module TopModule (
  input clk,
  input d,
  input r,
  output reg q
);

always @(posedge clk) begin
  if (r == 1'b1) begin
    q <= 1'b0; // Reset output 'q' to '0' on reset signal 'r' assertion
  end else begin
    q <= d; // Update output 'q' with input 'd' on positive clock edge
  end
end

endmodule