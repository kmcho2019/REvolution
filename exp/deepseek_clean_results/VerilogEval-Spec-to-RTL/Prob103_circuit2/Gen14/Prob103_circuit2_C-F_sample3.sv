module TopModule (
    input  a,       // First input bit
    input  b,       // Second input bit
    input  c,       // Third input bit
    input  d,       // Fourth input bit
    output q        // Even parity output (1 when even number of 1s in inputs)
);
    // Single XNOR operation implements even parity check
    // Output is 1 when an even number of inputs are 1 (including zero)
    assign q = ~(a ^ b ^ c ^ d);
endmodule