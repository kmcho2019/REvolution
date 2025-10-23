module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Directly add a and b and assign the result to s
    assign s = a + b;
    
    // Detect overflow by considering the carry into and out of the MSB
    // This can be achieved by checking if the most significant bit of the result differs from the sign bits of a and b
    // Additionally, we consider the carry into the MSB by checking if the sum of the two numbers exceeds the maximum value for 8-bit 2's complement
    assign overflow = (a[7] == b[7] && a[7] != s[7]) || ((a[7] == 1 && b[7] == 1 && s[7] == 0) || (a[7] == 0 && b[7] == 0 && s[7] == 1));

endmodule