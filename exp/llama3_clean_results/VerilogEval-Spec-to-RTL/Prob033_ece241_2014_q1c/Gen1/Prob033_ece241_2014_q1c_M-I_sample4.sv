module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Directly add a and b and assign the result to s
    assign s = a + b;
    
    // Detect overflow by checking if the sign bit of the result differs from the sign bits of a and b
    assign overflow = (a[7] == b[7]) && (a[7]!= s[7]);

endmodule