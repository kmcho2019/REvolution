(* optimize_power = "true" *)
(* optimize_area = "true" *)
module TopModule(
    input a,
    input b,
    input c,
    input d /* synthesis syn_unconnected_input=1 keep = 0 */,  // Explicitly marked and optimized as don't-care
    output out
);
    /* Implements minimized K-map (sum of products):
       cd\ab  01  00  10  11
       00 | d | 0 | 1 | 1 |
       01 | 0 | 0 | d | d |
       11 | 0 | 1 | 1 | 1 |
       10 | 0 | 1 | 1 | 1 |
       
       Minimal SOP: out = a + b'·c
       All don't-cares are optimally utilized to minimize the expression
    */
    
    (* keep = 0 *) wire b_n;  // Mark intermediate signal for potential optimization
    
    assign b_n = ~b;
    assign out = a | (b_n & c);
    
    // Timing constraint for critical path
    (* max_delay = "0.5 ns" *) wire out_timing;
    assign out_timing = out;
endmodule