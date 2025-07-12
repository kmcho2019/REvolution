module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout       // Carry-out output
);

    // Temporary wires for intermediate results
    wire [3:0] binary_sum;
    wire [3:0] corrected_sum;
    reg [3:0] Sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 (1001 in binary) and apply correction if necessary
    always @(*) begin
        if (binary_sum > 9) begin
            corrected_sum = binary_sum + 6;  // Apply correction
            Cout = 1'b1;  // Generate carry-out
        end else begin
            corrected_sum = binary_sum;
            Cout = 1'b0;  // No carry-out
        end
        Sum = corrected_sum;
    end

endmodule