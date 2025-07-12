module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire signed [8:0] sum_ext;

    // Extend inputs to signed 9 bits for overflow detection
    assign sum_ext = {a[7], a} + {b[7], b};
    assign s = sum_ext[7:0];

    // Overflow detection: when input signs match but output sign differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);
endmodule