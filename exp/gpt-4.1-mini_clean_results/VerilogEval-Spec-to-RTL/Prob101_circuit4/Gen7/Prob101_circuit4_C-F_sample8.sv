module TopModule(
    input  a,  // Unused in logic: included for interface completeness
    input  b,  // Determines output q when high
    input  c,  // Determines output q when high
    input  d,  // Unused in logic: included for interface completeness
    output q
);

// Output is high if either b or c is high; inputs a and d do not affect q
assign q = b | c;

endmodule