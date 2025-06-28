module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1;
  end else begin
    q <= {q[4] ^ q[2], q[4:1]}; // Calculate next state based on XOR of bit 5 and bit 3 with bit 0
  end
end

endmodule