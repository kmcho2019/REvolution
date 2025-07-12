module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum
    output Cout      // Carry-out output
);

    wire [4:0] bin_sum; // Temporary variable to hold binary sum of A, B, and Cin
    assign bin_sum = A + B + Cin; // Perform binary addition of A, B, and Cin

    reg [3:0] corrected_sum; // Variable to hold the corrected sum after BCD correction
    reg Cout_reg; // Variable to hold the carry-out

    always @(A or B or Cin) begin // Run the following logic whenever A, B, or Cin changes
        if (bin_sum > 9) begin // If binary sum exceeds 9
            corrected_sum = bin_sum + 6; // Correct the sum by adding 6
            Cout_reg = 1'b1; // Generate a carry-out
        end else begin
            corrected_sum = bin_sum[3:0]; // If sum is within BCD range, directly assign
            Cout_reg = 1'b0; // No carry-out
        end
    end

    assign Sum = corrected_sum; // Assign the corrected sum to the output Sum
    assign Cout = Cout_reg; // Assign the carry-out to the output Cout

endmodule