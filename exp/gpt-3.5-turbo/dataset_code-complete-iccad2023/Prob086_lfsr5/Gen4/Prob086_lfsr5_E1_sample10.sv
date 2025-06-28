module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

reg [1:0] xor_taps; // Register to store the XOR values for taps 5 and 3

always @* begin
  xor_taps = {q[4] ^ q[2], q[4] ^ q[0]}; // Calculate XOR values for taps 5 and 3
end

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end else begin
    q <= {xor_taps[1], q[4:1]}; // Update LFSR with XOR values for tap positions 5 and 3
  end
end

endmodule