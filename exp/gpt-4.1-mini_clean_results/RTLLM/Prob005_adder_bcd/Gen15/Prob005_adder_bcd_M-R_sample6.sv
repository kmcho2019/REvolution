module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       needs_correction;
    wire [4:0] corrected_sum;

    // First, perform 4-bit addition with carry-in, 5-bit result
    assign raw_sum = A + B + Cin;

    // Correction needed if either:
    // - Carry out from 4-bit addition is 1 (raw_sum[4] == 1), or
    // - Result's 4 LSBs > 9 (i.e. (raw_sum[3] & (raw_sum[2] | raw_sum[1])) or raw_sum[3] & raw_sum[0])
    assign needs_correction = raw_sum[4] | 
                              ( (raw_sum[3] & (raw_sum[2] | raw_sum[1])) );

    // If correction needed, add 6 (0110) to raw_sum
    assign corrected_sum = raw_sum + (needs_correction ? 5'd6 : 5'd0);

    // Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = needs_correction;

endmodule