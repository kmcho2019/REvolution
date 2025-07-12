module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply correction if necessary
    reg [3:0] corrected_sum;
    always @(A or B or Cin) begin
        if (binary_sum > 9) begin
            // Apply correction by adding 6 to the sum
            corrected_sum = binary_sum[3:0] + 4'b0110;
            // Generate carry-out
            Cout = 1'b1;
        end else begin
            corrected_sum = binary_sum[3:0];
            Cout = binary_sum[4];
        end
    end

    // Assign the corrected sum to the output
    assign Sum = corrected_sum;

endmodule