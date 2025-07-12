module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;

    // Overflow if sum > 9, detected by carry out of bit 3 or bit3 set along with bit1 or bit2
    wire overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    wire [4:0] corrected_sum = raw_sum + (overflow ? 5'd6 : 5'd0);

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule