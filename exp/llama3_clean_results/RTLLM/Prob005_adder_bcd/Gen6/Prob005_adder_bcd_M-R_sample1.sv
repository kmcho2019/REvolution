module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input       Cin, // Carry-in input
    output reg [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output reg      Cout  // Carry-out output
);

    // Temporary wire to hold the binary sum
    wire [4:0] bin_sum;
    assign bin_sum = A + B + Cin;

    // Determine if BCD correction is needed
    wire correction_needed = (bin_sum > 9);

    // Calculate the final sum with BCD correction
    assign Sum = correction_needed ? (bin_sum + 6)[3:0] : bin_sum[3:0];

    // Generate carry-out
    assign Cout = correction_needed || bin_sum[4];

endmodule