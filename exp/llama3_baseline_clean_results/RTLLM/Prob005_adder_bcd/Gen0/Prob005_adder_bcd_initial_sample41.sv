module adder_bcd(
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input         Cin,  // Carry-in input
    output  [3:0] Sum,  // 4-bit output representing the BCD sum
    output        Cout   // Carry-out output
);

    reg [4:0] sum_temp;  // Temporary sum variable to hold the result of A + B + Cin

    always @(*) begin
        // Perform binary addition of A, B, and Cin
        sum_temp = A + B + Cin;
        
        // If the sum exceeds 9 (1001 in binary), add 6 to correct it
        if (sum_temp > 9) begin
            Sum = sum_temp + 6;  // Correct the sum
            Cout = 1'b1;  // Generate a carry-out
        end else begin
            Sum = sum_temp[3:0];  // Directly assign the sum
            Cout = 1'b0;  // No carry-out
        end
    end

endmodule