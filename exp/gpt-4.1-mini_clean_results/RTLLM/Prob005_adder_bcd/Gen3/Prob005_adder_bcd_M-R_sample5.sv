module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: Raw binary addition of inputs
    wire [4:0] raw_sum = A + B + Cin;  // 5-bit to hold carry-out

    // Step 2: Detect if BCD correction is required
    // Correction needed if raw_sum > 9:
    // (MSB set) or (bit3 and (bit2 or bit1)) set
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: BCD correction addition of 6 (0110) when needed
    // Implement as ripple carry adder: sum_low + 6
    wire [3:0] sum_low = raw_sum[3:0];
    wire [3:0] correction = 4'b0110;

    // Correction addition ripple carry signals
    wire c0 = correction_needed; // initiate carry-in only if correction_needed
    wire c1, c2, c3;

    wire s0 = sum_low[0] ^ (correction_needed & correction[0]) ^ 1'b0;
    wire carry0 = (sum_low[0] & (correction_needed & correction[0])) | 
                  ((sum_low[0] ^ (correction_needed & correction[0])) & 1'b0);

    // Actually correction[0] = 0, so simplify s0 and carry0:
    wire s0_corrected = sum_low[0];
    wire carry0_corrected = 1'b0;

    // Bit 1
    wire s1 = sum_low[1] ^ (correction_needed & correction[1]) ^ carry0_corrected;
    wire c1 = (sum_low[1] & (correction_needed & correction[1])) | 
              ((sum_low[1] ^ (correction_needed & correction[1])) & carry0_corrected);

    // Bit 2
    wire s2 = sum_low[2] ^ (correction_needed & correction[2]) ^ c1;
    wire c2 = (sum_low[2] & (correction_needed & correction[2])) | 
              ((sum_low[2] ^ (correction_needed & correction[2])) & c1);

    // Bit 3
    wire s3 = sum_low[3] ^ (correction_needed & correction[3]) ^ c2;
    wire c3 = (sum_low[3] & (correction_needed & correction[3])) | 
              ((sum_low[3] ^ (correction_needed & correction[3])) & c2);

    // Step 4: Select corrected sum and carry out if needed, else raw_sum
    assign Sum  = correction_needed ? {s3, s2, s1, s0_corrected} : sum_low;
    assign Cout = correction_needed ? (c3 | raw_sum[4]) : raw_sum[4];

endmodule