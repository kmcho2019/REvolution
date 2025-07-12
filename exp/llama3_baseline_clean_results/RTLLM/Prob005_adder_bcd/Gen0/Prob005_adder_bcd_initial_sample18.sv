module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] sum_binary;  // Temporary variable to hold the binary sum
    always @(A or B or Cin) begin
        sum_binary = A + B + Cin;
    end

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    always @(sum_binary) begin
        if (sum_binary > 9) begin
            Sum = sum_binary + 6;  // Apply BCD correction
            Cout = 1'b1;  // Generate carry-out
        end else begin
            Sum = sum_binary[3:0];  // Assign the sum to the output
            Cout = 1'b0;  // No carry-out
        end
    end

endmodule