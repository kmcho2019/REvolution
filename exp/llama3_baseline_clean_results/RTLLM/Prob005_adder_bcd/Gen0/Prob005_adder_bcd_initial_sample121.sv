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

    // Check if the sum exceeds 9 (binary 1001)
    wire sum_exceeds_9;
    assign sum_exceeds_9 = (binary_sum > 4'd9);

    // Add 6 to the sum if it exceeds 9
    reg [3:0] corrected_sum;
    always @(binary_sum, sum_exceeds_9) begin
        if (sum_exceeds_9) begin
            // Correct the sum and generate a carry-out
            corrected_sum = binary_sum[3:0] + 4'd6;
        end else begin
            // Assign the binary sum to the corrected sum
            corrected_sum = binary_sum[3:0];
        end
    end

    // Assign the corrected sum to the output Sum
    assign Sum = corrected_sum;

    // Assign the carry-out to Cout
    assign Cout = (sum_exceeds_9 || binary_sum[4]);

endmodule