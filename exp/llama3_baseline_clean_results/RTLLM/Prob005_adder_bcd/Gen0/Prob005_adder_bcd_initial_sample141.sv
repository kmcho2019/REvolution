module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    reg [4:0] temp_sum; // Temporary sum to hold the result of A + B + Cin
    reg [3:0] corrected_sum; // Final sum after BCD correction
    reg Cout_reg; // Register to hold the carry-out value

    // Perform binary addition of A, B, and Cin
    always @(A, B, Cin) begin
        temp_sum = A + B + Cin;
        
        // Check if the sum exceeds 9 and apply BCD correction if necessary
        if (temp_sum > 9) begin
            corrected_sum = temp_sum + 6;
            Cout_reg = 1; // Set carry-out to 1 if sum exceeds 9
        end else begin
            corrected_sum = temp_sum;
            Cout_reg = 0; // Reset carry-out to 0 if sum is within BCD range
        end
        
        // Assign the corrected sum to the output
        Sum = corrected_sum[3:0];
        Cout = Cout_reg;
    end

endmodule