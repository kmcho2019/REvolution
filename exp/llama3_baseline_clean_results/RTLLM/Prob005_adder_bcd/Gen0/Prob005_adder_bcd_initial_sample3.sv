module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

    // Temporary sum from binary addition of A, B, and Cin
    wire [4:0] temp_sum;
    assign temp_sum = A + B + Cin;

    // Check if the temporary sum exceeds 9 (binary 1001)
    // If it does, add 6 to correct it to a valid BCD digit and set Cout to 1
    always @(A, B, Cin) begin
        if (temp_sum >= 10) begin
            Sum = temp_sum + 6;
            Cout = 1;
        end
        // If the sum does not exceed 9, the temporary sum is the correct BCD sum, and Cout is 0
        else begin
            Sum = temp_sum[3:0];  // Assign only the lower 4 bits to Sum
            Cout = 0;
        end
    end

endmodule