module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       overflow;
    wire [4:0] corrected_sum;
    wire       corr_cout;

    // Step 1: Add inputs with carry-in
    assign raw_sum = A + B + Cin;

    // Step 2: Detect BCD overflow using logic:
    // overflow if raw_sum > 9, which can be detected by:
    // raw_sum[4] == 1 (carry out) OR
    // (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: If overflow, add 6 (0110) to low nibble of raw_sum
    wire [4:0] correction = {1'b0, 4'b0110};
    wire [4:0] addend = overflow ? correction : 5'b0;

    assign {corr_cout, corrected_sum[3:0]} = raw_sum[3:0] + addend[3:0];
    assign corrected_sum[4] = raw_sum[4] + addend[4] + corr_cout;

    // Step 4: Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule