module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Apply BCD correction if the sum exceeds 9
    reg [4:0] corrected_sum;
    always @(binary_sum) begin
        if (binary_sum > 9) begin
            corrected_sum = binary_sum + 6;
        end else begin
            corrected_sum = binary_sum;
        end
    end

    // Assign the corrected sum to the output Sum
    assign Sum = corrected_sum[3:0];

    // Generate carry-out if the result exceeds 9
    assign Cout = (corrected_sum > 9) ? 1'b1 : 1'b0;

endmodule