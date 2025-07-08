module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

  integer i;
  reg [7:0] partial_sums [0:31]; // 32 groups (last group only 255 - 31*8 = 255-248=7 bits)
  reg [7:0] sum0;
  
  always @(*) begin
    // Sum each 8-bit group
    for (i = 0; i < 31; i = i + 1) begin
      partial_sums[i] = in[i*8 +: 8][0] + in[i*8 +: 8][1] + in[i*8 +: 8][2] + in[i*8 +: 8][3] +
                        in[i*8 +: 8][4] + in[i*8 +: 8][5] + in[i*8 +: 8][6] + in[i*8 +: 8][7];
    end
    // Last group has 7 bits
    partial_sums[31] = in[248] + in[249] + in[250] + in[251] + in[252] + in[253] + in[254];
    
    // Sum all partial sums
    sum0 = 0;
    for (i = 0; i < 32; i = i + 1) begin
      sum0 = sum0 + partial_sums[i];
    end
    
    out = sum0;
  end

endmodule