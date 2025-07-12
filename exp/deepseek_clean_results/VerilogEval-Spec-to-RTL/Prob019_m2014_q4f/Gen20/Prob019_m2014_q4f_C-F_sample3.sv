module TopModule (
    input in1,
    input in2,
    output out
);
    /* Implementation of AND gate with inverted second input:
     * out = in1 AND (NOT in2)
     * This is the most efficient implementation using a single
     * continuous assignment with bitwise operators
     */
    assign out = in1 & ~in2;
endmodule