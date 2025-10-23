module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire correction_needed;
    wire [3:0] correction;
    wire [4:0] corrected_sum;

    // Step 1: Binary addition of A, B, and Cin
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Detect if correction is needed (sum > 9)
    // Condition: raw_sum > 9 == raw_sum[4] or (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Select correction 6 (0110) or 0 (0000) based on correction_needed
    assign correction = correction_needed ? 4'b0110 : 4'b0000;

    // Step 4: Add correction to raw_sum[3:0], extending to 5 bits to capture carry out
    assign corrected_sum = {1'b0, raw_sum[3:0]} + {1'b0, correction};

    // Step 5: Output sum and carry out from corrected sum
    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule