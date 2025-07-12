module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z
);
    always @(*) begin
        z = (A == B);  // Direct equality comparison
    end
    
    /* Implementation notes:
     * Synthesizes to same XNOR-AND structure as original
     * May be preferred for readability in some coding styles
     * Functionally identical to original implementation
     */
endmodule