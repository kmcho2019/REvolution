module TopModule (
    input x,
    input y,
    output reg z
);
    /* Implementation of z = (x^y) & x using procedural assignment
     * Same optimized logic: x & (x ^ y)
     * - Uses always block instead of continuous assignment
     * - Output declared as reg for procedural assignment
     * - Maintains all PPA benefits of original implementation
     */
    always @(*) begin
        z = x & (x ^ y);
    end
endmodule