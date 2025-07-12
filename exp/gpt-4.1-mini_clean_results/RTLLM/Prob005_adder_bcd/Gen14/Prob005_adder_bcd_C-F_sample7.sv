module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: 4-bit binary addition with carry-out (5 bits)
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Efficient Boolean logic to detect correction need
    // correction_needed if raw_sum > 9, i.e.,
    // either MSB set (raw_sum[4]==1) or bits[3] & (bits[2] | bits[1]) set
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add correction 6 (0110) if needed by simplified bitwise addition:
    // Add 6 only if correction_needed is true; otherwise pass raw_sum unchanged

    wire [3:0] sum_low = raw_sum[3:0];

    // Add bit 0: sum_low[0] + 0 + 0 = sum_low[0], carry out 0
    wire sum0 = sum_low[0];
    wire carry0 = 1'b0;

    // Add bit 1: sum_low[1] + 1 + carry0
    wire sum1 = sum_low[1] ^ 1'b1 ^ carry0;
    wire carry1 = (sum_low[1] & 1'b1) | ((sum_low[1] ^ 1'b1) & carry0);

    // Add bit 2: sum_low[2] + 1 + carry1
    wire sum2 = sum_low[2] ^ 1'b1 ^ carry1;
    wire carry2 = (sum_low[2] & 1'b1) | ((sum_low[2] ^ 1'b1) & carry1);

    // Add bit 3: sum_low[3] + 0 + carry2
    wire sum3 = sum_low[3] ^ 1'b0 ^ carry2;
    wire carry3 = (sum_low[3] & 1'b0) | ((sum_low[3] ^ 1'b0) & carry2);

    // Select output bits and carry depending on correction_needed
    wire [3:0] corrected_sum = correction_needed ? {sum3, sum2, sum1, sum0} : sum_low;
    wire       corrected_carry = correction_needed ? carry3 : 1'b0;

    // Output assignment
    assign Sum  = corrected_sum;
    assign Cout = corrected_carry | raw_sum[4];

endmodule