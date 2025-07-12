module TopModule #(
    parameter WIDTH = 8  // Default to 8-bit input
) (
    input [WIDTH-1:0] in,
    output parity
);
    /* Even parity calculation using XOR reduction
     * Synthesis tool will automatically optimize this
     * into an efficient XOR tree structure
     */
    (* use_xor = "yes" *)  // Synthesis attribute to prefer XOR implementation
    assign parity = ^in;
    
    // Alternative implementation comment for documentation:
    // For odd parity, would use: assign parity = ~^in;
endmodule