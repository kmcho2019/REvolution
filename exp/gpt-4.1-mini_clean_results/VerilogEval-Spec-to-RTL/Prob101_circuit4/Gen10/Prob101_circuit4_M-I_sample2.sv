module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,    // input d is unused per waveform analysis
    output wire q
);

// Output q is high if either b or c is high; inputs a and d do not affect output
assign q = b | c;

endmodule