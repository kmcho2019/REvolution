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

    // Apply BCD correction if the sum exceeds 9
    reg [3:0] corrected_sum;
    always @(binary_sum) begin
        if (binary_sum > 9) begin
            // Add 6 (0110 in binary) to the sum for BCD correction
            corrected_sum = binary_sum[3:0] + 4'd6;
            Cout = 1'b1; // Generate carry-out
        end else begin
            corrected_sum = binary_sum[3:0];
            Cout = 1'b0; // No carry-out
        end
    end

    // Assign the corrected sum to the output
    assign Sum = corrected_sum;

endmodule