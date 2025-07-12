module TopModule (
    input in,
    output out
);
    // Transmission gate NOT implementation
    wire out_n;
    
    // PMOS (passes 1 when gate is 0)
    tranif1 (out, 1'b1, in);
    
    // NMOS (passes 0 when gate is 1)
    tranif0 (out_n, 1'b0, in);
    
    // Combine outputs
    assign out = in ? out_n : out;
    
    /* Advantages:
     * 1. Symmetrical rise/fall times
     * 2. No static power consumption
     * 3. Can be more compact in some technologies
     * 4. Demonstrates switch-level design
     * 5. Works with any voltage levels
     */
endmodule