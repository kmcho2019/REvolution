module TopModule (
    input a,
    input b,
    output q
);
    // Output is 1 only when both inputs are 1 (AND operation)
    assign q = a & b;
endmodule