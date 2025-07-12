module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Initial 5-bit binary sum (A+B+Cin)
    wire [4:0] raw_sum = A + B + Cin;

    // Detect if correction needed: raw_sum > 9
    // Condition: correction_needed = MSB of raw_sum is 1 OR
    // bit3 is 1 AND (bit2 OR bit1 is 1)
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Lower 4 bits of raw sum
    wire [3:0] sum_low = raw_sum[3:0];

    // BCD correction: sum + 6 if correction_needed
    // Adding 6 (0110) to sum_low only when correction_needed is true
    // Use combinational logic derived from sum_low and correction_needed for each bit

    // corrected_sum bits calculation:
    // Bit 0: sum_low[0] (unchanged by adding 6)
    wire s0 = sum_low[0];

    // Bit 1: sum_low[1] XOR correction_needed
    wire s1 = sum_low[1] ^ correction_needed;

    // Bit 2: sum_low[2] XOR correction_needed
    wire s2 = sum_low[2] ^ correction_needed;

    // Bit 3: sum_low[3] if correction_needed=0 else sum_low[3] OR correction_needed
    // More precisely: s3 = sum_low[3] | correction_needed & sum_low[1]
    // From the truth table of sum_low+6, bit3 toggles if correction_needed and sum_low[1] is set
    wire s3 = sum_low[3] | (correction_needed & sum_low[1]);

    wire [3:0] corrected_sum = {s3, s2, s1, s0};

    // Carry out is simply correction_needed, since sum >9 triggers carry
    assign Sum  = corrected_sum;
    assign Cout = correction_needed;

endmodule