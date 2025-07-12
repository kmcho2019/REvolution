// TopModule that adds two 8-bit numbers and detects overflow
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Perform the addition
    assign s = a + b;

    // Detect overflow
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule