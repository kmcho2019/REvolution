module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1;
  end else begin
    // XOR feedback for Galois LFSR with taps at bit positions 5 and 3
    q <= {q[4] ^ q[2] ^ q[0], q[4:1]}; 
  end
end

endmodule