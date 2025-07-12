module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected;

    // 1. Perform 4-bit binary addition with carry-in
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // 2. Determine if correction needed: raw_sum > 9
    assign correction_needed = (raw_sum > 5'd9);

    // 3. If correction needed, subtract 10 (decimal) to get BCD digit and set Cout = 1
    assign corrected = correction_needed ? (raw_sum - 5'd10) : raw_sum;

    // 4. Assign outputs
    assign Sum  = corrected[3:0];
    assign Cout = correction_needed;

endmodule