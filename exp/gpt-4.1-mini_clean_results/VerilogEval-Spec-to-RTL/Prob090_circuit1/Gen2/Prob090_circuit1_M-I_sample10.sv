module TopModule(
    input a,
    input b,
    output q
);
    // Simple AND gate implementation matching waveform and optimal in PPA
    assign q = a & b;
endmodule