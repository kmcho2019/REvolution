module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: Perform 4-bit binary addition with carry out
    wire [4:0] bin_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Extract intermediate carries
    wire c3 = bin_sum[3];    // carry into bit 3
    wire c4 = bin_sum[4];    // carry out of the addition

    // Step 2: Determine if correction is needed
    // Correction needed if sum > 9 (i.e., c4 is set) or (bit3 is set and any of bits 2 or 1 are set)
    wire correction_needed = c4 | (c3 & (bin_sum[2] | bin_sum[1]));

    // Step 3: BCD correction by adding 6 (binary 0110) if needed
    // Use a single 5-bit addition for correction to minimize stages and maximize clarity
    wire [4:0] correction_value = correction_needed ? 5'd6 : 5'd0;
    wire [4:0] corrected_sum = bin_sum + correction_value;

    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule