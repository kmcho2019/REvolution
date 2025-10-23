module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: Perform initial binary addition with carry-in
    wire [4:0] bin_sum = A + B + Cin;

    // Step 2: Detect invalid BCD sum (sum > 9)
    // BCD digits 0..9 valid; invalid if sum > 9
    // sum[4] is carry from bit 3, sum[3:0] is sum bits
    wire invalid_bcd = bin_sum[4] | (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // Step 3: Generate correction bits by adding 6 (0110) conditionally using combinational logic
    // Instead of full addition, add 6 only to the bits where needed using XOR and carry chain
    wire c1 = invalid_bcd; // carry-in for correction adder (adding 6)
    wire s0 = bin_sum[0];  // bit 0 sum (no correction needed as 6 LSB is 0110)
    wire c2 = (bin_sum[1] & invalid_bcd) | (bin_sum[1] & c1) | (invalid_bcd & c1);
    wire s1 = bin_sum[1] ^ invalid_bcd ^ c1;
    wire c3 = (bin_sum[2] & c2) | (bin_sum[2] & invalid_bcd) | (c2 & invalid_bcd);
    wire s2 = bin_sum[2] ^ invalid_bcd ^ c2;
    wire s3 = bin_sum[3] ^ c3;
    wire c4 = (bin_sum[3] & c3) | (bin_sum[3] & invalid_bcd) | (c3 & invalid_bcd);

    // Step 4: Assign outputs
    assign Sum  = {s3, s2, s1, s0};
    assign Cout = c4;

endmodule