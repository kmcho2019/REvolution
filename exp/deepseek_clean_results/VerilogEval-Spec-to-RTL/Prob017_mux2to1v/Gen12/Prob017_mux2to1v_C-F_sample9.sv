module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Primary implementation: clear ternary operator
    assign out = sel ? b : a;
    
    /* Alternative implementations (commented out):
    // 1. Bitwise operation version (may offer different synthesis optimizations)
    // wire [99:0] mask = {100{sel}};
    // assign out = (a & ~mask) | (b & mask);
    
    // 2. Hierarchical version for large buses (better for some PPA scenarios)
    // genvar i;
    // generate
    //     for (i=0; i<100; i=i+1) begin: mux_gen
    //         assign out[i] = sel ? b[i] : a[i];
    //     end
    // endgenerate
    */

endmodule