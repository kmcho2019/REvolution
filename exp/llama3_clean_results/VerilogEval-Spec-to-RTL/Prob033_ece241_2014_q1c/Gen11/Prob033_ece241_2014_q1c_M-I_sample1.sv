// Improved TopModule that integrates adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Perform 8-bit addition
    assign s = a + b;

    // Detect overflow by comparing the most significant bits
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule