module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Output is high for all input combinations except when all inputs are zero
    assign out = a | b | c;
endmodule