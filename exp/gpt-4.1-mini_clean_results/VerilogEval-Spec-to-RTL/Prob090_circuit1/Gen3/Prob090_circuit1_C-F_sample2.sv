module TopModule (
    input  a,
    input  b,
    output q
);
    // Optimal combinational AND gate implementation:
    // Single assign ensures minimal area, power, and delay.
    assign q = a & b;
endmodule