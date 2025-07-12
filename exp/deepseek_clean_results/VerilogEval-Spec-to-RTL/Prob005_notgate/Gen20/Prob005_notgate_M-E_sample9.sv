module TopModule (
    input in,
    output out
);
    // 1-bit LUT implementation of NOT gate
    // LUT contents: out = ~address[0]
    reg [1:0] lut;
    
    initial begin
        // Program the LUT with NOT function
        lut[0] = 1'b1;  // Output when in=0
        lut[1] = 1'b0;  // Output when in=1
    end
    
    // Use input as LUT address
    assign out = lut[in];
    
    /* Implementation Notes:
     * - In an FPGA, this would map directly to a LUT1 primitive
     * - In ASIC, this would synthesize to the same as a NOT gate but with
     *   additional mux logic
     * - Demonstrates how more complex functions could be built by expanding
     *   the LUT size and address width
     */
endmodule