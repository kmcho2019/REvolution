module TopModule (
    input in1,
    input in2,
    output out
);
    /* Implements an AND gate with inverted in2 input:
     * out = in1 AND (NOT in2)
     * Gate-level equivalent: in1 --|‾‾‾|
     *                           | AND |-- out
     *                      in2--|___|
     * (Note: The bubble on in2 input represents inversion)
     */
    assign out = in1 & ~in2;
endmodule