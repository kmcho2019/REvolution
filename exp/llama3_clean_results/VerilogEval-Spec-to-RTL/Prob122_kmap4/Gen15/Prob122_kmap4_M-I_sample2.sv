module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // The existing implementation is already efficient and correct
    // Given the favorable PPA metrics, significant improvements might be challenging
    // without altering the design's functionality or leveraging technology-specific optimizations
    
    // Implementing the Karnaugh map logic using XOR operations
    assign out = (a ^ b) ^ (c ^ d);

endmodule