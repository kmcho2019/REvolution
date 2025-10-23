module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum
    output Cout     // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply correction
    reg [3:0] corrected_sum;
    reg carry_out;

    always @(*) begin
        if (binary_sum > 9) begin
            // Apply correction by adding 6
            corrected_sum = binary_sum + 6;
            // Since the sum exceeded 9, set carry_out
            carry_out = 1'b1;
        end else begin
            // No correction needed, just assign the sum
            corrected_sum = binary_sum[3:0];
            // No carry-out since sum is within BCD range
            carry_out = 1'b0;
        end
    end

    // Assign outputs
    assign Sum = corrected_sum;
    assign Cout = carry_out;

endmodule