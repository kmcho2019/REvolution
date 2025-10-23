module TopModule (
    input in,
    output out
);
    // Direct NOT gate implementation
    assign out = ~in;
    
    /* Architectural notes:
     * 1. Simpler and more efficient than LUT-based approach
     * 2. Directly maps to a single inverter primitive in ASIC/FPGA
     * 3. Lower power and area than LUT implementation
     * 4. Same functionality with better timing (single gate delay)
     */
endmodule