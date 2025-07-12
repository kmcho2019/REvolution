module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       carry_out_4bit;
    wire       needs_correction;
    wire [3:0] corrected_sum;

    // 4-bit binary addition with carry out
    assign {carry_out_4bit, raw_sum[3:0]} = A + B + Cin;
    assign raw_sum[4] = 1'b0; // explicitly zero unused bit for clarity

    // Determine if correction is needed:
    // Condition 1: carry_out_4bit == 1 (sum > 15 -> definitely > 9)
    // Condition 2: raw_sum[3:0] > 9 (i.e., raw_sum > 4'b1001)
    assign needs_correction = carry_out_4bit | 
                              ( (raw_sum[3] & (raw_sum[2] | raw_sum[1])) | (raw_sum[2] & raw_sum[1]) );

    // If correction needed, add 6 (0110) to raw_sum[3:0]
    wire [4:0] sum_after_correction;
    assign sum_after_correction = {1'b0, raw_sum[3:0]} + (needs_correction ? 5'b00110 : 5'b00000);

    assign Sum = sum_after_correction[3:0];
    assign Cout = sum_after_correction[4];

endmodule