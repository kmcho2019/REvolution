module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] binary_sum;
    wire carry_out;
    wire correction_needed;

    // Perform 4-bit binary addition
    assign {carry_out, binary_sum} = A + B + Cin;

    // Optimized correction detection: sum > 9 or carry occurred
    // Detects patterns: 1010-1111 (10-15) or carry_out
    assign correction_needed = (binary_sum[3] & (binary_sum[2] | binary_sum[1])) | carry_out;

    // Conditional correction: add 6 if needed
    assign {Cout, Sum} = correction_needed ? (binary_sum + 4'd6) : {carry_out, binary_sum};

endmodule