module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;

    // Initial addition: A + B + Cin
    assign raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9
    // Instead of full comparator, use logic:
    // correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));
    // This is a classic BCD correction condition detecting sums > 9
    wire correction_needed;
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Add 6 (0110) when correction_needed is asserted using minimal combinational logic
    // We'll implement addition of raw_sum[3:0] + 6 conditionally

    // Correction value bits
    localparam [3:0] SIX = 4'b0110;

    wire [3:0] corrected_sum;
    wire       carry_out_corr;

    // Bitwise addition with carry propagation for correction addition
    // Start with carry_in = correction_needed (0 or 1)
    // To add 6 only when correction_needed is set, we use the following:
    // If correction_needed=0, sum remains raw_sum[3:0]
    // If correction_needed=1, sum = raw_sum[3:0] + 6

    wire c0, c1, c2, c3; // carry signals between bits

    // Bit 0 addition
    assign {c0, corrected_sum[0]} = raw_sum[0] + (correction_needed & SIX[0]);

    // Bit 1 addition
    assign {c1, corrected_sum[1]} = raw_sum[1] + (correction_needed & SIX[1]) + c0;

    // Bit 2 addition
    assign {c2, corrected_sum[2]} = raw_sum[2] + (correction_needed & SIX[2]) + c1;

    // Bit 3 addition
    assign {c3, corrected_sum[3]} = raw_sum[3] + (correction_needed & SIX[3]) + c2;

    // The final carry out is c3 OR raw_sum[4] (carry from initial addition)
    // Because if initial sum had carry, or correction addition generated carry, carry out occurs
    assign Cout = c3 | raw_sum[4];

    assign Sum = corrected_sum;

endmodule