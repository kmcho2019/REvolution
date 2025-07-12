module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Direct combinational OR to implement the waveform output behavior
    assign q = b | c;
endmodule