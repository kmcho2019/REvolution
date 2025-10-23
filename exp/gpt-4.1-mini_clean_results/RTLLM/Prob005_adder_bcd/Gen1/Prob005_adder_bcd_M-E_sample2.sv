module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] sum_bin;       // 5-bit binary sum of A, B, Cin
    wire       correction;    // correction flag for BCD adjustment
    wire [4:0] sum_corrected; // sum after adding correction 6 if needed

    // Perform binary addition
    assign sum_bin = A + B + Cin;

    // Detect if correction is needed:
    // Correction if sum_bin > 9
    // sum_bin > 9 equivalent to sum_bin[4] == 1 (sum > 15) or sum_bin[3] & (sum_bin[2] | sum_bin[1])
    assign correction = sum_bin[4] | (sum_bin[3] & (sum_bin[2] | sum_bin[1]));

    // Add correction (6) when needed
    assign sum_corrected = correction ? (sum_bin + 5'd6) : sum_bin;

    // Output final BCD sum (lower 4 bits) and carry out (5th bit)
    assign Sum = sum_corrected[3:0];
    assign Cout = sum_corrected[4];

endmodule