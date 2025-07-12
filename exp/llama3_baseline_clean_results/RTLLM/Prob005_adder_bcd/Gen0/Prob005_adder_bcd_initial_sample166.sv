module adder_bcd(
    A,  // First BCD input (4-bit)
    B,  // Second BCD input (4-bit)
    Cin,  // Carry-in input (1-bit)
    Sum,  // 4-bit output representing the sum of the two BCD inputs
    Cout  // Carry-out output (1-bit)
);
    
    input [3:0] A;  // First BCD input
    input [3:0] B;  // Second BCD input
    input Cin;  // Carry-in input
    output [3:0] Sum;  // 4-bit output sum
    output Cout;  // Carry-out output

    reg [3:0] sum_binary;  // Binary sum of A, B, and Cin
    reg [3:0] sum_corrected;  // Corrected sum after BCD correction
    reg Cout_temp;  // Temporary carry-out

    // Perform binary addition
    always @(*) begin
        sum_binary = A + B + Cin;
        
        // Check if correction is needed
        if (sum_binary > 9) begin
            // Apply BCD correction
            sum_corrected = sum_binary + 6;
            // Generate carry-out if sum exceeds 9 after correction
            Cout_temp = (sum_binary[3] == 1) ? 1'b1 : 1'b0;
        end else begin
            // No correction needed, use binary sum directly
            sum_corrected = sum_binary;
            // Generate carry-out based on binary sum
            Cout_temp = (sum_binary > 9) ? 1'b1 : 1'b0;
        end
        
        // Assign outputs
        Sum = sum_corrected[3:0];
        Cout = Cout_temp;
    end

endmodule