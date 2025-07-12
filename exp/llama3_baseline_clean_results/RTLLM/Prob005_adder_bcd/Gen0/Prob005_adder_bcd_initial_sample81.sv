module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // Apply BCD correction if sum exceeds 9
    reg [4:0] bcd_sum;
    always @(*) begin
        if (binary_sum > 9) begin
            bcd_sum = binary_sum + 6; // Add 6 for BCD correction
        end else begin
            bcd_sum = binary_sum;
        end
    end

    // Assign Sum and Cout
    assign Sum = bcd_sum[3:0]; // Assign the lower 4 bits of bcd_sum to Sum
    assign Cout = bcd_sum[4];  // Assign the most significant bit of bcd_sum to Cout

endmodule