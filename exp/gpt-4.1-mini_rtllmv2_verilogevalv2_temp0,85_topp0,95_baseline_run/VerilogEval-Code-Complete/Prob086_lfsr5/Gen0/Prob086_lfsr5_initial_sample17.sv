module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  // Tap positions: 5 and 3 => bits 4 and 2 (zero-based)
  wire feedback = q[0];

  always @(posedge clk) begin
    if (reset)
      q <= 5'b00001;
    else begin
      q[0] <= q[1];
      q[1] <= q[2];
      q[2] <= q[3] ^ feedback; // tap at bit 3 (index 2)
      q[3] <= q[4];
      q[4] <= feedback ^ q[4]; // tap at bit 5 (index 4)
    end
  end

endmodule