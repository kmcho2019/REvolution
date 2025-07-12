module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;

    // Overflow detection for BCD: sum > 9
    wire overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    wire [4:0] corrected_sum = raw_sum + 5'd6;

    // Select corrected sum if overflow, else raw sum
    assign Sum  = overflow ? corrected_sum[3:0] : raw_sum[3:0];
    assign Cout = overflow ? corrected_sum[4]   : raw_sum[4];

endmodule