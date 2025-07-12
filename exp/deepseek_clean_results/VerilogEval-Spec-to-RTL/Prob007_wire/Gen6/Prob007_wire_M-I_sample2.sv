module TopModule (
    input in,
    output out
);
    // This is identical to the original because it's already optimal
    assign out = in;
    
    // Alternative implementations would be worse:
    // always @(*) out = in;  // Procedural version (same PPA)
    // buf b1(out, in);      // Primitive version (same PPA)
endmodule