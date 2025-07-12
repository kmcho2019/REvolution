module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// The existing solution is already quite efficient.
// To potentially improve timing and reduce power, consider output buffering.
// However, for such a simple design, this might not yield significant benefits.
assign q = b | c;

endmodule