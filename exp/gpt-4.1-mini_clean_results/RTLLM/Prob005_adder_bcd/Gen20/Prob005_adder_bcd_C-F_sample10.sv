module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction;

    // Step 1: 4-bit addition plus carry-in, 5-bit to capture overflow
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if correction needed (raw_sum > 9) using minimal logic
    assign correction = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditionally add correction value 6 (0110) to raw_sum
    wire [4:0] corrected_sum = raw_sum + (correction ? 5'd6 : 5'd0);

    // Step 4: Assign outputs - lower 4 bits for Sum, MSB for carry-out
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule