module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [8:0] sum_ext;

    assign sum_ext = {a[7], a} + {b[7], b}; // extend sign to 9 bits to catch carry out

    assign s = sum_ext[7:0];
    // Overflow occurs if the carry into MSB and carry out of MSB differ.
    // Alternatively, overflow if sign of a == sign of b but sign of s != sign of a
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule