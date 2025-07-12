module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Perform the addition and store the result in s
    assign s = a + b;

    // Detect overflow by checking if the sign bit of the result is different from the sign bits of the inputs
    assign overflow = (a[7] == b[7] && a[7]!= s[7]);

endmodule