module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Perform 8-bit 2's complement addition
    assign s = a + b;

    // Detect overflow by checking if the MSB of the result is set
    assign overflow = (a[7] == b[7] && a[7]!= s[7]);

endmodule