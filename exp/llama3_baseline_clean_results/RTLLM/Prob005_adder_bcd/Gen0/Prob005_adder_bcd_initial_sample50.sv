module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input       Cin,
    output [3:0] Sum,
    output       Cout
);

    // Internal signal to hold the binary sum of A, B, and Cin
    reg [4:0] binary_sum;

    // Perform binary addition of A, B, and Cin
    always @(*) begin
        binary_sum = A + B + Cin;
    end

    // Apply BCD correction and generate carry-out if necessary
    always @(*) begin
        if (binary_sum > 9) begin
            // Apply correction and generate carry-out
            Sum = binary_sum + 6;
            Cout = 1'b1;
        end else begin
            // No correction needed, just assign the sum
            Sum = binary_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule