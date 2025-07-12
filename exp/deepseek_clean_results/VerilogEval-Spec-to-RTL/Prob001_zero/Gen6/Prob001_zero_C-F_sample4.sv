module TopModule (
    output zero
);
    // Optimal implementation - direct constant assignment
    assign zero = 1'b0;
    
    /* Pedagogical note: This synthesizes identically to:
     * wire sel;  // Don't-care select signal
     * assign zero = sel ? 1'b0 : 1'b0;
     * because modern synthesis tools optimize away unnecessary logic
     * and collapse constant expressions
     */
endmodule