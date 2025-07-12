module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input       Cin, // Carry-in input
    output  [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output      Cout  // Carry-out output
);

    // Temporary variable to hold the binary sum
    reg [4:0] bin_sum;

    // Perform binary addition of A, B, and Cin
    always @(A, B, Cin) begin
        bin_sum = A + B + Cin;
    end

    // BCD correction and carry generation
    always @(bin_sum) begin
        if (bin_sum > 9) begin
            Sum = bin_sum + 6; // BCD correction
            Cout = 1'b1;       // Generate carry-out
        end else begin
            Sum = bin_sum[3:0]; // Direct sum if no correction needed
            Cout = 1'b0;        // No carry-out
        end
    end

endmodule