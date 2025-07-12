module TopModule (
    input wire a,  // unused input, kept for interface compliance
    input wire b,
    input wire c,
    input wire d,  // unused input, kept for interface compliance
    output wire q
);
    // Output q is high if either b or c is high, per waveform data.
    assign q = b | c;
endmodule