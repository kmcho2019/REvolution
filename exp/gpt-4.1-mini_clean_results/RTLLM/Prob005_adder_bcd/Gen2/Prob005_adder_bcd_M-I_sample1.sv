module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] bin_sum;       // 5-bit to hold sum + carry
    wire       need_correction;
    wire [4:0] corrected_sum;

    // Binary addition of inputs and carry-in
    assign bin_sum = A + B + Cin;

    // Determine if correction is needed (sum > 9)
    assign need_correction = (bin_sum > 5'd9);

    // Instead of adding 6 via full adder, add 6 by bitwise logic for correction:
    // Adding 6 (0110) to the bin_sum only if correction is needed
    // corrected_sum = bin_sum + 6 if needed, else bin_sum
    // Implement addition by bits:
    wire c1, c2, c3; // carry bits for partial addition
    wire [4:0] bin_sum_plus6;

    // bit 0: bin_sum[0] + 0 + 0
    assign bin_sum_plus6[0] = bin_sum[0];

    // bit 1: bin_sum[1] + 1 + 0
    assign {c1, bin_sum_plus6[1]} = bin_sum[1] + 1'b1;

    // bit 2: bin_sum[2] + 1 + c1
    assign {c2, bin_sum_plus6[2]} = bin_sum[2] + 1'b1 + c1;

    // bit 3: bin_sum[3] + 0 + c2
    assign {c3, bin_sum_plus6[3]} = bin_sum[3] + c2;

    // bit 4: bin_sum[4] + c3
    assign bin_sum_plus6[4] = bin_sum[4] + c3;

    // Select corrected sum or original bin_sum
    assign corrected_sum = need_correction ? bin_sum_plus6 : bin_sum;

    // Output sum is the lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is the MSB of corrected sum (bit 4)
    assign Cout = corrected_sum[4];

endmodule