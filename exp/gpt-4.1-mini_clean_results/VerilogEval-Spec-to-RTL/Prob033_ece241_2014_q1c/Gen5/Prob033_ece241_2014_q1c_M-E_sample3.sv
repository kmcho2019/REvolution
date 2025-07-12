module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);
    // Cast inputs as signed 8-bit values
    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;
    wire signed [8:0] sum_extended; // 9 bits to hold possible overflow bit

    assign sum_extended = a_signed + b_signed;
    assign s = sum_extended[7:0];

    // Overflow if sign(a) == sign(b) but sign(s) != sign(a)
    assign overflow = ((a_signed[7] == b_signed[7]) && (s[7] != a_signed[7]));

endmodule