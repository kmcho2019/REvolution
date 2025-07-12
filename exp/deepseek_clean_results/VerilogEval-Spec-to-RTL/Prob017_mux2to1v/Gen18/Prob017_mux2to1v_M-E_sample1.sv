module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Create a 100-bit mask based on the select signal
    wire [99:0] mask = {100{sel}};

    // Bitwise parallel processing:
    // For each bit position:
    //   if mask bit is 0 -> select a's bit
    //   if mask bit is 1 -> select b's bit
    assign out = (~mask & a) | (mask & b);

    /* Implementation Notes:
     * 1. The mask generation creates a 100-bit vector where all bits equal 'sel'
     * 2. The actual selection happens through bitwise AND/OR operations
     * 3. This implementation may have better power characteristics in some technologies
     *    because it avoids the conditional operator's potential for glitching
     * 4. Synthesis tools can optimize this into efficient pass-gate or AOI logic
     * 5. Particularly effective for wide buses in ASIC implementations
     */
endmodule