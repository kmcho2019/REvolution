module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end else begin
    q <= {q[3] ^ q[0], q[4], q[3], q[2], q[1]}; // LFSR shifting logic with XOR gates at tap positions 5 and 3
  end
end

endmodule