module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Optimal implementation: OR of all inputs
    // Matches Karnaugh map (output 1 unless a=b=c=0)
    // Single gate implementation minimizes delay/area/power
    wire out = a | b | c;
endmodule