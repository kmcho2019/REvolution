module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Create 100-bit mask where all bits = sel
    wire [99:0] mask = {100{sel}};
    
    // Bitwise selection logic
    assign out = (a & ~mask) | (b & mask);

endmodule