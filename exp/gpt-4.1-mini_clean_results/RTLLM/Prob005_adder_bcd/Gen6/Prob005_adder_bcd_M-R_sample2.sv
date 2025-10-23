module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] binary_sum;
    wire       overflow;
    wire [4:0] correction;
    wire [5:0] corrected_sum;

    // Step 1: Add A, B and Cin (5-bit to keep carry out)
    assign binary_sum = A + B + Cin;

    // Step 2: Detect BCD overflow using explicit logic:
    // Overflow occurs if sum > 9, which can be detected if:
    //   1) carry out of bit 3 (binary_sum[4]) is set OR
    //   2) bit3 is set AND (bit2 is set OR bit1 is set)
    assign overflow = (binary_sum[4]) | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Step 3: Determine correction (6 = 0110) if overflow, else zero
    assign correction = overflow ? 5'd6 : 5'd0;

    // Step 4: Add correction to binary_sum (5-bit + 5-bit = 6-bit)
    assign corrected_sum = binary_sum + correction;

    // Step 5: Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule