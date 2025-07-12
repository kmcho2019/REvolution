module TopModule(
    input a,
    input b,
    input c,
    input d /* synthesis syn_unconnected_input=1 */,  // Explicitly marked as don't-care
    (* optimize_power *) output out
);
    /* Implements K-map:
       cd\ab  01  00  10  11
       00 | d | 0 | 1 | 1 |
       01 | 0 | 0 | d | d |
       11 | 0 | 1 | 1 | 1 |
       10 | 0 | 1 | 1 | 1 |
    */
    assign out = a | (~b & c);
endmodule