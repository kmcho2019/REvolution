module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    /* synthesis 
       direct_enable = "no"
       dont_touch = "yes"
       keep_hierarchy = "yes"
    */
    
    // Even parity detection using technology-optimized implementation
    assign q = ~(a ^ b ^ c ^ d);  // Maintains optimal XNOR implementation
    
    // Formal property verification
    // psl default clock = posedge(clk);
    // psl parity_check: assert always (q == !($countones({a,b,c,d}) % 2));

endmodule