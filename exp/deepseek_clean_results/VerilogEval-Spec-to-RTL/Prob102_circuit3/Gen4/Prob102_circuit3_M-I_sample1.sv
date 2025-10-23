module TopModule (
    input  a,    // First selector input
    input  b,    // Second selector input
    input  c,    // First data input
    input  d,    // Second data input
    output q     // Output signal
);

    // Logic function:
    // q = (a OR b) AND (c OR d)
    // Output is high when:
    //   - At least one selector (a or b) is active, AND
    //   - At least one data input (c or d) is active
    assign q = ( (a | b) & (c | d) );

endmodule