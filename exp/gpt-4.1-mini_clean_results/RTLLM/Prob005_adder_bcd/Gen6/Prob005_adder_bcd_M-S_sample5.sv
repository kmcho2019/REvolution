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

    // 5-bit binary addition of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Check if sum exceeds 9 (decimal)
    assign correction_needed = (raw_sum > 5'd9);

    // Add 6 if correction needed
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule