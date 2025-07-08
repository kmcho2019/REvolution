module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);
  // Tap positions (1-based): 5 and 3 => zero-based: 4 and 2
  wire feedback = q[0];

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // reset output to 1
    end else begin
      q[0] <= q[1];
      q[1] <= q[2];
      q[2] <= q[3] ^ feedback; // tap at bit 3 (q[2])
      q[3] <= q[4];
      q[4] <= feedback ^ q[4]; // tap at bit 5 (q[4])
    end
  end
endmodule