module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] binary_sum;
    wire [3:0] corrected_sum;
    reg [3:0] Sum;
    reg Cout;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction
    always @(binary_sum) begin
        if (binary_sum > 9) begin
            // Apply correction and generate carry-out
            Sum = binary_sum + 6;
            Cout = 1;
        end else begin
            // No correction needed, just assign the sum
            Sum = binary_sum;
            Cout = 0;
        end
    end

endmodule