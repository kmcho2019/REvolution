module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    assign sum_ext = {a[7], a} + {b[7], b}; // 9-bit addition to detect overflow
    assign s = sum_ext[7:0];

    // Overflow occurs if the carry into the sign bit and carry out differ,
    // equivalently if the sign of the result is different from the inputs when inputs have the same sign
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);
endmodule