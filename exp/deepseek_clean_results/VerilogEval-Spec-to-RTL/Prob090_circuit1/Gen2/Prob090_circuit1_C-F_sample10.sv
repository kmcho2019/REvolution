module TopModule (
    input a,    // First input signal
    input b,    // Second input signal
    output q    // Output (logical AND of inputs)
);
    // Combinational logic: q is 1 only when both a AND b are 1
    assign q = a & b;
endmodule