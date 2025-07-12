module TopModule(a, b, c, d, out);
  input a;
  input b;
  input c;
  input d;
  output out;

  reg [3:0] index;
  reg [0:0] lut[0:15];

  initial begin
    lut[0] = 0;  // 0000
    lut[1] = 1;  // 0001
    lut[2] = 0;  // 0010
    lut[3] = 1;  // 0011
    lut[4] = 1;  // 0100
    lut[5] = 0;  // 0101
    lut[6] = 1;  // 0110
    lut[7] = 0;  // 0111
    lut[8] = 0;  // 1000
    lut[9] = 1;  // 1001
    lut[10] = 0;  // 1010
    lut[11] = 1;  // 1011
    lut[12] = 1;  // 1100
    lut[13] = 0;  // 1101
    lut[14] = 1;  // 1110
    lut[15] = 0;  // 1111
  end

  always @(*) begin
    index = {a, b, c, d};
    out = lut[index];
  end
endmodule