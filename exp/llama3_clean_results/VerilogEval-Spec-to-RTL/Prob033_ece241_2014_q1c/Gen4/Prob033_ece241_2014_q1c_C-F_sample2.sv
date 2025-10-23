module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Perform signed addition to handle 2's complement numbers correctly
    assign s = $signed(a) + $signed(b);
    
    // Detect overflow by comparing the sign bits of the inputs with the sign bit of the result
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule