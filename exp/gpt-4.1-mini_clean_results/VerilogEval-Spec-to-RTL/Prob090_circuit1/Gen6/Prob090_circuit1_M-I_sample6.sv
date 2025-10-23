module TopModule(
    input  a,
    input  b,
    output q
);
    // Declare q as wire implicitly (default), explicitly declared here for clarity
    wire q;

    // Combinational logic: q is high only when both a and b are high (AND function)
    assign q = a & b;
endmodule