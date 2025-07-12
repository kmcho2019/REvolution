module TopModule (
    input  a, b, c, d,
    output q
);
    // Priority encoder implementation
    // b has higher priority than c
    // a and d are unused (tied to enable)
    wire enable = 1'b1;
    
    assign q = enable & (b | c);
endmodule