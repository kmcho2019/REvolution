module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] sum;
    
    // Perform the addition
    assign sum = a + b;
    assign s = sum;
    
    // Overflow detection using sign comparison
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum[7]);
endmodule