module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    // Perform addition with an extra bit to capture carry out
    assign sum_ext = {1'b0, a} + {1'b0, b};
    assign s = sum_ext[7:0];

    // Overflow detection: if sign of a and b are same, but sign of sum differs, overflow occurred
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);
endmodule