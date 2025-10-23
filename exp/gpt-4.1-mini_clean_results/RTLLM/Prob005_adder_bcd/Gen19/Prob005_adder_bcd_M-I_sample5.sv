module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] sum_with_cin;
    wire       correction;

    // Compute raw sum of A, B and Cin
    assign sum_with_cin = A + B + Cin;

    // Detect if correction is needed (sum > 9)
    assign correction = sum_with_cin[4] | (sum_with_cin[3] & (sum_with_cin[2] | sum_with_cin[1]));

    // Add correction (6) in the same addition to get final sum and carry-out
    // 5-bit addition: sum_with_cin + (correction ? 6 : 0)
    wire [4:0] corrected_sum = sum_with_cin + (correction ? 5'd6 : 5'd0);

    // Assign outputs
    assign {Cout, Sum} = corrected_sum;

endmodule