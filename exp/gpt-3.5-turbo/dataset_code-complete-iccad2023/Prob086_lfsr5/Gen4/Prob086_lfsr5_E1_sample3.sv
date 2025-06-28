module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1;
  end
  else begin
    reg tap_XOR;
    tap_XOR = q[4] ^ q[2]; // XOR tap positions 5 and 3 with q[0]

    q <= {tap_XOR, q[4:1]}; // LFSR shifting with XORed tap values
  end
end

endmodule