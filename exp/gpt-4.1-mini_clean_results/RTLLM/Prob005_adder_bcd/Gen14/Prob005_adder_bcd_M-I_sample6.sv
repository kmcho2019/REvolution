module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;

    // Overflow detection: sum > 9 
    wire overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add correction (6) only if overflow
    wire [4:0] corrected_sum_temp = raw_sum + 5'd6;

    // Select between raw_sum and corrected_sum_temp based on overflow
    wire [4:0] corrected_sum = overflow ? corrected_sum_temp : raw_sum;

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule