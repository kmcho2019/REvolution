module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire [4:0] corrected_sum;
    wire       correction_needed;

    // Binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Determine if correction is needed:
    // correction is needed if sum > 9 (1001) or if carry out from binary addition (bit 4) is set
    assign correction_needed = (raw_sum[4]) | (raw_sum[3:0] > 4'd9);

    // Add 6 (0110) to the raw sum if correction is needed
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output the lower 4 bits as the BCD sum
    assign Sum = corrected_sum[3:0];

    // Carry out if after correction the value exceeds 9 (which means bit 4 is set) or initial carry out set
    assign Cout = corrected_sum[4];

endmodule