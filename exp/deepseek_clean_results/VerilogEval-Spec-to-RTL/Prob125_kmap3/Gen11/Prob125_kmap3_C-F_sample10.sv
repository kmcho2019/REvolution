module TopModule(
    input a,
    input b,
    input c,
    input d /* synthesis syn_unconnected_input=1 */,  // Explicitly mark don't-care
    (* optimize_power = 1, optimize_area = 1 *) output out
);
    /* Implements K-map:
       cd\ab  01  00  10  11
       00 | d | 0 | 1 | 1 |
       01 | 0 | 0 | d | d |
       11 | 0 | 1 | 1 | 1 |
       10 | 0 | 1 | 1 | 1 |
       Minimal SOP: out = a + ~b·c
    */
    assign out = a | (~b & c);
endmodule