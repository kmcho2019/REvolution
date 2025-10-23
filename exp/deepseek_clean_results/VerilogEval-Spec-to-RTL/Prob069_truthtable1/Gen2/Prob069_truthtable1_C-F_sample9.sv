module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Intermediate terms with timing constraints
    (* optimize_power *)
    wire term1 = ~x3 & x2;  // Active when x3=0 and x2=1 (rows 3-4)
    
    (* optimize_power *)
    wire term2 = x3 & x1;   // Active when x3=1 and x1=1 (rows 6,8)

    // Final OR operation with critical path annotation
    (* max_delay = "1.0" *)
    assign f = term1 | term2;

    /* Truth Table Reference:
    x3 x2 x1 | f
    ---------|---
    0  0  0 | 0
    0  0  1 | 0
    0  1  0 | 1 (term1)
    0  1  1 | 1 (term1)
    1  0  0 | 0
    1  0  1 | 1 (term2)
    1  1  0 | 0
    1  1  1 | 1 (term2)
    */
endmodule