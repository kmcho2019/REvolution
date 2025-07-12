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

    // Perform 5-bit addition
    assign raw_sum = A + B + Cin;

    // Detect if correction is needed: sum > 9
    // sum > 9 if bit4==1 (sum >=16) OR (bit3==1 and (bit2==1 or bit1==1))
    // since 9 = 1001b; values > 9 have bit3=1 and either bit2 or bit1 =1
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 if correction needed
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule