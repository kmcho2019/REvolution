module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, ignored for simplification
    output out
);

wire not_a = ~a;
wire not_b = ~b;
wire not_c = ~c;

// From the K-map:
// Minterms with output=1:
// For cd=00 (c=0,d=0): ab=10(1),11(1) => a=1,b=0 and a=1,b=1 => a=1 and c=0
// For cd=00: ab=10 and 11 => output=1
// For cd=11 (c=1,d=1): ab=00(1),10(1),11(1) => b=0 or a=1 (simplify)
// For cd=10 (c=1,d=0): ab=00(1),10(1),11(1) => similarly b=0 or a=1
// For cd=00: output=1 when a=1 and c=0
// For cd=11 or 10: output=1 when a=1 or b=0 and c=1

// Simplified boolean from analysis:
// out = (a & ~c) | (c & (~b | a))

assign out = (a & ~c) | (c & (~b | a));

endmodule