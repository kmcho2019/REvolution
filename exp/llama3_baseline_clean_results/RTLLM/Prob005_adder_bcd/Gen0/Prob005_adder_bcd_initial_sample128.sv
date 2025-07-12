module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [4:0] sum_binary; // Temporary variable to hold the binary sum

    // Perform binary addition
    always @(*) begin
        sum_binary = A + B + Cin;

        // Apply BCD correction if necessary
        if (sum_binary > 9) begin
            Sum = sum_binary + 6;
            Cout = 1'b1; // Set carry-out
        end else begin
            Sum = sum_binary[3:0]; // Take the lower 4 bits as the BCD sum
            Cout = 1'b0; // Reset carry-out
        end
    end

endmodule