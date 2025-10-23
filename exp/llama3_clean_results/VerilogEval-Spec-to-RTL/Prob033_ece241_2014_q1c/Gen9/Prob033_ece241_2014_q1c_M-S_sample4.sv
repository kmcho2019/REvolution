module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Perform the addition and assign the result to s
    assign s = a + b;

    // Detect signed overflow by checking the most significant bits
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule