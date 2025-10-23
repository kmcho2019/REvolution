module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Intermediate XOR results for clear parity calculation
    wire parity_ab, parity_cd;
    wire odd_parity;
    
    // First level XORs (input pairing)
    assign parity_ab = a ^ b;
    assign parity_cd = c ^ d;
    
    // Final XOR combines partial results
    assign odd_parity = parity_ab ^ parity_cd;
    
    // Invert for even parity output
    assign q = ~odd_parity;
endmodule