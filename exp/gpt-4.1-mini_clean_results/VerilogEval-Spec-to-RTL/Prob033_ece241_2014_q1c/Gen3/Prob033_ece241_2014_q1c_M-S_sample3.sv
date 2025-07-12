module TopModule(
    input  signed [7:0] a,
    input  signed [7:0] b,
    output [7:0] s,
    output overflow
);
    wire signed [8:0] sum = a + b;
    assign s = sum[7:0];
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum[7]);
endmodule