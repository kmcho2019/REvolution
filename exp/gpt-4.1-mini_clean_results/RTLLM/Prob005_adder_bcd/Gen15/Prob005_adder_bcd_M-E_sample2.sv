module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Step 1: Binary addition of inputs with carry-in (5 bits to hold carry)
    assign binary_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Detect if correction is needed (sum > 9)
    // Correction needed if:
    // - MSB (bit 4) is set (sum >= 16),
    // - OR sum[3] & (sum[2] | sum[1]) is set (sum > 9)
    assign correction_needed = (binary_sum[4] == 1'b1) || 
                               (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Step 3: Add 6 (0110) for BCD correction if needed
    // Use a 4-bit adder to add 6 to the lower 4 bits of the sum
    // Carry-in to correction adder is zero because we add exactly 6
    wire [4:0] correction_sum = {1'b0, binary_sum[3:0]} + 5'd6;

    // Step 4: Select between original sum and corrected sum based on correction_needed
    assign Sum  = correction_needed ? correction_sum[3:0] : binary_sum[3:0];
    assign Cout = correction_needed;

endmodule