module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @(*) begin
    // Form 2-bit vectors
    wire [1:0] ab = {a, b};
    wire [1:0] cd = {c, d};
    wire [1:0] xor_ab_cd = ab ^ cd;

    // Output is 1 if xor_ab_cd equals 1 or 2 (i.e. one bit difference)
    out = (xor_ab_cd == 2'b01) || (xor_ab_cd == 2'b10);
  end

endmodule