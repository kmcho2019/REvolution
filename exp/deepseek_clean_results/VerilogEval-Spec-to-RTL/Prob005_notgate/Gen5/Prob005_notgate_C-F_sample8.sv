module TopModule (
    input in,
    output out
);
    /* Truth table for NOT gate:
     * in | out
     * ---|----
     * 0  | 1
     * 1  | 0
     */
    assign out = ~in;
endmodule