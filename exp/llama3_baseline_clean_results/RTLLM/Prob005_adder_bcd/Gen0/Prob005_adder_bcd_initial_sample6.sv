module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;

    // Perform binary addition
    assign binary_sum = A + B + Cin;

    // Apply BCD correction if sum exceeds 9
    always @(A, B, Cin) begin
        if (binary_sum > 9) begin
            // Add 6 for BCD correction and generate carry-out
            Sum = binary_sum + 6;
            Cout = 1'b1;
        end else begin
            // No correction needed, just assign the sum and no carry-out
            Sum = binary_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule