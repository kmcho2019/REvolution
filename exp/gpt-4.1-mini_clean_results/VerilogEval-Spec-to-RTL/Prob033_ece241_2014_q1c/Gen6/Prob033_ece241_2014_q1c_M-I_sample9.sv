module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [8:0] sum_ext;
    assign sum_ext = {1'b0, a} + {1'b0, b}; // extend to 9 bits to avoid warnings

    assign s = sum_ext[7:0];

    // Overflow detection: overflow if sign of a and b are same but differ from s
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule