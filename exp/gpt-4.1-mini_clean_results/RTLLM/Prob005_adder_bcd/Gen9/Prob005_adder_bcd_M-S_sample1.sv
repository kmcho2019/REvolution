module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Initial binary sum (5 bits to hold carry out)
    wire [4:0] bin_sum = A + B + Cin;

    // Condition for correction: sum > 9 or carry out is set
    wire need_correction = (bin_sum[4] == 1'b1) || (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // Correction value 6 if needed, else 0
    wire [4:0] correction = need_correction ? 5'd6 : 5'd0;

    // Corrected sum after adding 6 if needed
    wire [4:0] corrected_sum = bin_sum + correction;

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule