module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    wire [99:0] mask = {100{sel}};  // Replicate sel to 100 bits
    
    assign out = (a & ~mask) | (b & mask);

endmodule