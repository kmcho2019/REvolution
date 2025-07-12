module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // Note: d is not used in the logic based on the provided waveform
    output q
);

assign q = a || b || c;

endmodule