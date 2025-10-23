module adder_bcd(
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input         Cin,  // Carry-in input
    output  [3:0] Sum,  // 4-bit output representing the sum
    output        Cout   // Carry-out output
);

    // Temporary sum without considering BCD correction
    wire [4:0] temp_sum;
    assign temp_sum = A + B + Cin;
    
    // Check if the sum exceeds 9 (1001 in binary), if yes, add 6 (0110 in binary) for BCD correction
    reg [3:0] corrected_sum;
    always @(*) begin
        if (temp_sum > 9) begin
            corrected_sum = temp_sum + 6;
        end else begin
            corrected_sum = temp_sum[3:0]; // Take only the lower 4 bits
        end
    end
    
    // Assign the corrected sum to the output
    assign Sum = corrected_sum;
    
    // Generate carry-out if the result exceeds 9 or if there was a carry from the original sum
    assign Cout = (temp_sum > 9) || (temp_sum[4] == 1);
    
endmodule