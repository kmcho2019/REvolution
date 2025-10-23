module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Treat inputs as signed 8-bit numbers
    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;
    wire signed [8:0] sum_ext; // 9 bits to hold carry out if any

    assign sum_ext = a_signed + b_signed;
    assign s = sum_ext[7:0];

    // Overflow if sign of a and b are same but different from sum
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule