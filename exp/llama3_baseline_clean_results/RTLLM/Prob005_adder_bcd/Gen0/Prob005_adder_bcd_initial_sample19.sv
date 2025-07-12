module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the binary sum exceeds 9 (1001 in binary)
    reg [4:0] corrected_sum;
    always @(A or B or Cin) begin
        if (binary_sum > 4'd9) begin
            // Apply correction by adding 6 to the sum
            corrected_sum = binary_sum + 4'd6;
            // Generate carry-out (Cout) if the result exceeds a single decimal digit
            Cout = 1'b1;
        end else begin
            corrected_sum = binary_sum;
            Cout = 1'b0;
        end
    end

    // Assign the corrected sum to the output, taking only the lower 4 bits
    assign Sum = corrected_sum[3:0];

endmodule