module TopModule (
    input [7:0] in,
    output parity
);
    // Implementation note:
    // This hierarchical structure documents the XOR tree structure
    // while maintaining optimal implementation through synthesis
    
    // First level XORs (conceptual grouping)
    wire [3:0] l1 = {
        in[7] ^ in[6],
        in[5] ^ in[4],
        in[3] ^ in[2],
        in[1] ^ in[0]
    };
    
    // Second level XORs
    wire [1:0] l2 = {
        l1[3] ^ l1[2],
        l1[1] ^ l1[0]
    };
    
    // Final XOR
    assign parity = l2[1] ^ l2[0];
    
    // Alternative one-line implementation (commented out):
    // assign parity = ^in;
endmodule