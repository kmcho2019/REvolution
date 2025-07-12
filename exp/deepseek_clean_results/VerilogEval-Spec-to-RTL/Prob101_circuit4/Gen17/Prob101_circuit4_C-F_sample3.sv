module TopModule (
    input  a, b, c, d,
    output q
);
    // Output q is the OR of inputs b and c
    // Note: Inputs a and d are unused in this implementation
    assign q = b | c;
endmodule