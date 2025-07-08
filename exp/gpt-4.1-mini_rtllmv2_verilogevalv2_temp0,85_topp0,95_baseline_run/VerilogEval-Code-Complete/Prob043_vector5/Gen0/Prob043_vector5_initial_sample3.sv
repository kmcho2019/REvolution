module TopModule (
  input  a,
  input  b,
  input  c,
  input  d,
  input  e,
  output [24:0] out
);

  assign out = {
    ~(a ^ a),  // bit 24
    ~(a ^ b),  // bit 23
    ~(a ^ c),  // bit 22
    ~(a ^ d),  // bit 21
    ~(a ^ e),  // bit 20
    ~(b ^ a),  // bit 19
    ~(b ^ b),  // bit 18
    ~(b ^ c),  // bit 17
    ~(b ^ d),  // bit 16
    ~(b ^ e),  // bit 15
    ~(c ^ a),  // bit 14
    ~(c ^ b),  // bit 13
    ~(c ^ c),  // bit 12
    ~(c ^ d),  // bit 11
    ~(c ^ e),  // bit 10
    ~(d ^ a),  // bit 9
    ~(d ^ b),  // bit 8
    ~(d ^ c),  // bit 7
    ~(d ^ d),  // bit 6
    ~(d ^ e),  // bit 5
    ~(e ^ a),  // bit 4
    ~(e ^ b),  // bit 3
    ~(e ^ c),  // bit 2
    ~(e ^ d),  // bit 1
    ~(e ^ e)   // bit 0
  };

endmodule