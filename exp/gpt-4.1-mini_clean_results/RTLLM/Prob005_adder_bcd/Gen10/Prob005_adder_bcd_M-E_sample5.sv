module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] adjusted_sum;

    // 4-bit binary addition with carry-in
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Correction needed if sum > 9
    assign correction_needed = (raw_sum > 5'd9);

    // If correction is needed, subtract 10 (binary 01010) from raw_sum to get valid BCD digit
    assign adjusted_sum = correction_needed ? (raw_sum - 5'd10) : raw_sum;

    // Output sum and carry-out
    assign Sum  = adjusted_sum[3:0];
    assign Cout = correction_needed;

endmodule