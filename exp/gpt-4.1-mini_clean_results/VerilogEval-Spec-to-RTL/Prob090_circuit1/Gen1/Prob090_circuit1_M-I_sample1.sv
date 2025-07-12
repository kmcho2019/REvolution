module TopModule(
    input a,
    input b,
    output q
);
    // Minimal AND gate implementation - optimal for all PPA metrics
    assign q = a & b;
endmodule