module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Initialize the LFSR output to 1
  end else begin
    q <= {q[4] ^ q[0], q[0], q[1], q[2], q[3]}; // LFSR implementation with taps at bit positions 5 and 3
  end
end

endmodule