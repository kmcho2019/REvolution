module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_parity, cd_parity;
    wire odd_parity;
    
    // Calculate parity of a and b
    assign ab_parity = a ^ b;
    
    // Calculate parity of c and d
    assign cd_parity = c ^ d;
    
    // Combine to get overall odd parity
    assign odd_parity = ab_parity ^ cd_parity;
    
    // Invert to get even parity
    assign q = ~odd_parity;

endmodule