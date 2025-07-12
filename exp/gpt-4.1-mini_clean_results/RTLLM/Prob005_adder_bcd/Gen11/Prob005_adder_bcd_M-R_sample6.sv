module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Perform binary addition of inputs plus carry-in
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Detect if correction is needed:
    // sum > 9 if (bit4 == 1) or (bit3 ==1 and bit1==1) or (bit3==1 and bit2==1)
    // i.e. raw_sum > 9 when:
    // raw_sum[4] == 1 (sum >= 16)
    // or raw_sum[3] & (raw_sum[2] | raw_sum[1]) == 1
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 (binary 0110) if correction is needed
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule