module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Output q is high if either b or c is high (q = b OR c)
    assign q = b | c;

    // Note: inputs 'a' and 'd' are unused based on the waveform and can be kept for interface completeness
endmodule