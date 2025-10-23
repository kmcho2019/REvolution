module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] initial_sum;       // 5-bit sum of A+B+Cin
    wire       needs_correction;  // flag if sum > 9
    wire [3:0] corrected_sum;
    wire       correction_carry;

    // Step 1: initial 5-bit binary addition
    assign initial_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: detect if correction is needed
    // Correction needed if sum > 9
    // sum > 9 when:
    // - MSB of initial_sum is 1 (sum >= 16)
    // - or lower 4 bits > 9
    assign needs_correction = (initial_sum[4]) | (initial_sum[3:0] > 4'd9);

    // Step 3: If correction needed, add 6 to lower 4 bits, else keep lower 4 bits as is
    // Using a 4-bit adder for correction to reduce delay
    wire [4:0] correction_sum = {1'b0, initial_sum[3:0]} + (needs_correction ? 5'd6 : 5'd0);

    // Step 4: Assign outputs
    assign Sum  = correction_sum[3:0];
    assign Cout = needs_correction ? correction_sum[4] : initial_sum[4];

endmodule