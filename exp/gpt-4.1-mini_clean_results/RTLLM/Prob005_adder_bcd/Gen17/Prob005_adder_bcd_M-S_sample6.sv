module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction;
    wire [4:0] corrected_sum;

    // Add A, B and carry-in
    assign raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9
    assign correction = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Correct sum by adding 6 if correction needed, using combinational logic without a second adder
    assign corrected_sum = correction ? raw_sum + 5'd6 : raw_sum;

    // Output assignments
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule