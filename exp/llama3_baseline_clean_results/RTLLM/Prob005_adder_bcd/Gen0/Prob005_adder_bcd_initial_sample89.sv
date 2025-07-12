module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output       Cout   // Carry-out output
);

    // Binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // BCD correction and carry generation
    always @(*) begin
        if (binary_sum > 9) begin
            // Apply BCD correction by adding 6
            Sum = binary_sum + 6;
            // Generate carry-out
            Cout = 1'b1;
        end else begin
            Sum = binary_sum[3:0];  // Assign the lower 4 bits of the binary sum
            Cout = 1'b0;  // No carry-out if sum is within BCD range
        end
    end

endmodule