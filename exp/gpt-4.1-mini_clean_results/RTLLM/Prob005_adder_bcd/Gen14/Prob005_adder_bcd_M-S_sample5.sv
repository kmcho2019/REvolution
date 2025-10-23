module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction;

    // 5-bit sum of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9
    assign correction = (raw_sum[4]) | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 if correction needed
    assign {Cout, Sum} = correction ? (raw_sum + 5'd6) : raw_sum;

endmodule