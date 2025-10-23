module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] sum_raw;
    wire       overflow;

    // Raw binary addition of A, B, and Cin
    assign sum_raw = A + B + Cin;

    // Overflow if sum > 9 or carry out of bit3 is set
    assign overflow = (sum_raw > 5'd9);

    // Add 6 to correct if overflow, else no correction
    assign {Cout, Sum} = overflow ? (sum_raw + 5'd6) : sum_raw;

endmodule