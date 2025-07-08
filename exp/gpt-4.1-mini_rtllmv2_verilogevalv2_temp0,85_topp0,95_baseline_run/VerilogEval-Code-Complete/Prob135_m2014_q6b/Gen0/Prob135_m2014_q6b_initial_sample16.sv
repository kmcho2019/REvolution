module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

  wire is_B = (~y[3]) & (~y[2]) & y[1]; // 001
  wire is_C = (~y[3]) & y[2] & (~y[1]); // 010
  wire is_E = y[3] & (~y[2]) & (~y[1]); // 100
  wire is_F = y[3] & (~y[2]) & y[1];    // 101

  always @(*) begin
    Y2 = is_B | (is_C & w) | (is_E & w) | is_F;
  end

endmodule