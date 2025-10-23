module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,    // Carry-in input
    output [3:0] Sum, // 4-bit output representing the BCD sum
    output Cout    // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] temp_sum;
    always @(A or B or Cin) begin
        temp_sum = A + B + Cin;
    end

    // BCD correction and carry generation
    always @(temp_sum) begin
        if (temp_sum > 9) begin
            // Apply BCD correction by adding 6
            Sum = temp_sum + 6;
            // Generate carry-out
            Cout = 1;
        end else begin
            Sum = temp_sum;
            // No carry-out if sum is within BCD range
            Cout = 0;
        end
    end

endmodule