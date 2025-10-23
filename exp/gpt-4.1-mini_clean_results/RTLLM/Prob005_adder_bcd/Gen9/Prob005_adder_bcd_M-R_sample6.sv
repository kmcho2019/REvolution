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

    // Use the same Boolean condition for correction
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Combine correction addition in a single expression
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule