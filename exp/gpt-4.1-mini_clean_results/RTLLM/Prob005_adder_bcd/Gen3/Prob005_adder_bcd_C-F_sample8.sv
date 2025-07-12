module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;         // 5-bit sum to hold carry out
    wire       correction_needed;
    wire [3:0] corrected_sum;
    wire       c1, c2, c3;      // internal carries for correction adder

    // Step 1: 5-bit binary addition of inputs A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Step 2: Detect if correction is needed using minimal logic:
    // correction_needed = raw_sum > 9
    // optimized condition for correction:
    // correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add 6 (0110) only if correction_needed using combinational logic adder:
    // Perform: corrected_sum = raw_sum[3:0] + (correction_needed ? 6 : 0)
    // Using half/full adder style logic for efficient +6 addition:

    // Bit 0 addition: raw_sum[0] + 0 + 0 carry_in = raw_sum[0]
    assign corrected_sum[0] = raw_sum[0];

    // Bit 1 addition: raw_sum[1] + 1*correction_needed + carry_in(bit0)
    assign corrected_sum[1] = raw_sum[1] ^ correction_needed;

    assign c1 = raw_sum[1] & correction_needed;

    // Bit 2 addition: raw_sum[2] + 1*correction_needed + carry c1
    assign corrected_sum[2] = raw_sum[2] ^ correction_needed ^ c1;

    assign c2 = (raw_sum[2] & correction_needed) | (raw_sum[2] & c1) | (correction_needed & c1);

    // Bit 3 addition: raw_sum[3] + 0 + carry c2 (since bit3 of 6 is 0)
    assign corrected_sum[3] = raw_sum[3] ^ c2;

    assign c3 = raw_sum[3] & c2;

    // Step 4: Assign outputs
    assign Sum  = correction_needed ? corrected_sum : raw_sum[3:0];
    assign Cout = correction_needed; // Cout is 1 if correction is done, meaning sum > 9

endmodule