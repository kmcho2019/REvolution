module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    assign raw_sum = A + B + Cin;

    // Correction is needed if sum > 9 or if carry out of bit 3 is set
    assign correction_needed = (raw_sum[4] == 1'b1) || (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule