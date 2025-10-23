module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] correction;
    wire [4:0] corrected_sum;

    // Step 1: Perform 4-bit binary addition with carry-in, result is 5 bits
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction needed using Boolean condition
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Generate 5-bit correction value based on correction_needed
    // Correction value is 6 (0110) zero-extended to 5 bits if correction_needed, else zero
    assign correction = correction_needed ? 5'b00110 : 5'b00000;

    // Step 4: Add correction to raw_sum
    assign corrected_sum = raw_sum + correction;

    // Step 5: Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule