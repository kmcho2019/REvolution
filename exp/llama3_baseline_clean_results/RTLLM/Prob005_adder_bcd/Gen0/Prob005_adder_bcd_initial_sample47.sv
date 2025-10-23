module adder_bcd (
    input   [3:0] A,
    input   [3:0] B,
    input         Cin,
    output  [3:0] Sum,
    output        Cout
);

// Perform binary addition of A, B, and Cin
reg [4:0] binary_sum;
always @(*) begin
    binary_sum = A + B + Cin;
end

// Apply BCD correction if the sum exceeds 9
always @(*) begin
    if (binary_sum > 9) begin
        // Add 6 to correct the sum and generate carry-out
        Sum = binary_sum + 6;
        Cout = 1'b1;
    end else begin
        // No correction needed, just pass the sum and set carry-out to 0
        Sum = binary_sum[3:0];  // Ensure Sum is 4 bits
        Cout = 1'b0;
    end
end

endmodule