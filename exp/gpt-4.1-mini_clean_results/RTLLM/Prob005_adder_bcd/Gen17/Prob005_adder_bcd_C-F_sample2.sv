module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: 4-bit binary addition with 5-bit result to capture carry-out
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Efficient correction detection (raw_sum > 9)
    // Correction needed if MSB set or bits 3 and (2 or 1) set
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add correction value 6 (0110) conditionally using bitwise adder
    // Inputs to correction adder: raw_sum[3:0] + 6 when correction_needed else raw_sum[3:0]
    wire [3:0] sum_low = raw_sum[3:0];

    // Bit 0 addition: sum_low[0] + 0 + 0 carry-in
    wire sum0 = sum_low[0];
    wire carry0 = 1'b0;

    // Bit 1 addition: sum_low[1] + correction bit1 (1) + carry0
    wire sum1 = sum_low[1] ^ 1'b1 ^ carry0;
    wire carry1 = (sum_low[1] & 1'b1) | ((sum_low[1] ^ 1'b1) & carry0);

    // Bit 2 addition: sum_low[2] + correction bit2 (1) + carry1
    wire sum2 = sum_low[2] ^ 1'b1 ^ carry1;
    wire carry2 = (sum_low[2] & 1'b1) | ((sum_low[2] ^ 1'b1) & carry1);

    // Bit 3 addition: sum_low[3] + correction bit3 (0) + carry2
    wire sum3 = sum_low[3] ^ 1'b0 ^ carry2;
    wire carry3 = (sum_low[3] & 1'b0) | ((sum_low[3] ^ 1'b0) & carry2);

    // Select corrected sum and carry based on correction_needed
    wire [3:0] corrected_sum = correction_needed ? {sum3, sum2, sum1, sum0} : sum_low;
    wire       corrected_carry = correction_needed ? carry3 : 1'b0;

    // Output assignments
    assign Sum  = corrected_sum;
    assign Cout = corrected_carry | raw_sum[4];

endmodule