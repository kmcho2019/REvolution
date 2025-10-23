module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire signed [8:0] sum_ext;

    assign sum_ext = $signed(a) + $signed(b);
    assign s = sum_ext[7:0];
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule