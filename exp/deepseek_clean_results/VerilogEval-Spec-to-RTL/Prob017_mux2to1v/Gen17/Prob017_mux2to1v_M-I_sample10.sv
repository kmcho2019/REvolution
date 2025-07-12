module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Direct conditional mux implementation
    assign out = sel ? b : a;

    /* Advantages:
     * 1. Cleaner and more readable code
     * 2. Reduced logic depth (single mux operation vs mask generation + logic)
     * 3. Lets synthesis tool choose optimal implementation
     * 4. Still maintains full parallel bitwise operation
     * 5. Easier to modify or extend if needed
     */
endmodule