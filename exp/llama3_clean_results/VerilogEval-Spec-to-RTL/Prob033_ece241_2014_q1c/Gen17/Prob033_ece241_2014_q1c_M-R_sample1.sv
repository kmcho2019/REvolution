module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Perform 8-bit addition and check for overflow
    assign {overflow, s} = a + b;

    // Signed overflow detection logic
    // assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule