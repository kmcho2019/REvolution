module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Calculate masked versions
    wire [99:0] a_masked = a & {100{~sel}};
    wire [99:0] b_masked = b & {100{sel}};
    
    // Combine masked versions
    assign out = a_masked | b_masked;

endmodule