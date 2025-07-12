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

    // Check if the binary sum exceeds 9 (1001 in binary)
    wire exceeds_nine;
    assign exceeds_nine = (binary_sum > 4'd9) ? 1'b1 : 1'b0;

    // Add correction of 6 if the sum exceeds 9
    reg [3:0] corrected_sum;
    always @(binary_sum or exceeds_nine) begin
        if (exceeds_nine) begin
            // Since we only need to consider the 4 least significant bits for BCD,
            // and we know binary_sum > 9, we add 6 (0110 in binary) to the lower 4 bits
            // which effectively adjusts the sum to be within BCD range
            corrected_sum = binary_sum[3:0] + 4'd6;
        end else begin
            corrected_sum = binary_sum[3:0];
        end
    end

    // Assign the corrected sum to the output
    assign Sum = corrected_sum;

    // Generate carry-out (Cout) if the binary sum exceeds 9
    assign Cout = exceeds_nine;

endmodule