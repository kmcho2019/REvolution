module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // The output q is high if either b or c is high, regardless of a and d.
    // Inputs a and d are intentionally unused as per waveform behavior.
    assign q = b | c;
endmodule