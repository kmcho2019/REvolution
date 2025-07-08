module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);
  wire [4:0] signals = {a, b, c, d, e};
  // Indexing: signals[4]=e ... signals[0]=a, so reverse for clarity:
  // Let's reorder so signals[0]=a, signals[1]=b, etc.
  // The problem states out[24] = ~a ^ a, so a corresponds to index 0.
  wire [4:0] sigs = {a, b, c, d, e};

  assign out = {
    ~(a ^ a), ~(a ^ b), ~(a ^ c), ~(a ^ d), ~(a ^ e),
    ~(b ^ a), ~(b ^ b), ~(b ^ c), ~(b ^ d), ~(b ^ e),
    ~(c ^ a), ~(c ^ b), ~(c ^ c), ~(c ^ d), ~(c ^ e),
    ~(d ^ a), ~(d ^ b), ~(d ^ c), ~(d ^ d), ~(d ^ e),
    ~(e ^ a), ~(e ^ b), ~(e ^ c), ~(e ^ d), ~(e ^ e)
  };
endmodule