module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Create a 100-bit mask based on sel
    wire [99:0] mask = {100{sel}};
    
    // Implement mux using bitwise operations
    assign out = (b & mask) | (a & ~mask);

endmodule