module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Parallel computation of sum bits
    wire [3:0] sum_bits = A ^ B;
    wire [3:0] carry_gen = A & B;
    wire [3:0] carry_prop = A | B;

    // Carry lookahead computation
    wire c1 = carry_gen[0] | (carry_prop[0] & Cin);
    wire c2 = carry_gen[1] | (carry_prop[1] & c1);
    wire c3 = carry_gen[2] | (carry_prop[2] & c2);
    wire c4 = carry_gen[3] | (carry_prop[3] & c3);

    // Intermediate sum before correction
    wire [3:0] pre_sum = {sum_bits[3] ^ c3,
                      sum_bits[2] ^ c2,
                      sum_bits[1] ^ c1,
                      sum_bits[0] ^ Cin};

    // Efficient correction detection (sum > 9 or carry)
    wire correction_needed = c4 | 
                           (pre_sum[3] & (pre_sum[2] | pre_sum[1]));

    // Optimized correction application (bitwise +6)
    wire [3:0] corrected_sum = {
        pre_sum[3] ^ (correction_needed & (pre_sum[2] | pre_sum[1])),
        pre_sum[2] ^ (correction_needed & ~(pre_sum[3] & pre_sum[1])),
        pre_sum[1] ^ correction_needed,
        pre_sum[0]
    };

    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = correction_needed;

endmodule