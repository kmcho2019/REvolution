module adder_bcd(A, B, Cin, Sum, Cout);
    input [3:0] A;  // First BCD input
    input [3:0] B;  // Second BCD input
    input Cin;      // Carry-in input
    output [3:0] Sum;  // Sum output
    output Cout;     // Carry-out output

    // Perform binary addition of A, B, and Cin
    reg [4:0] temp_sum;  // Temporary sum, 5 bits to handle carry
    always @(A or B or Cin) begin
        temp_sum = A + B + Cin;
        
        // Check if the sum exceeds 9 (BCD correction)
        if (temp_sum > 9) begin
            // Add 6 to the sum and set Cout to 1
            Sum = (temp_sum + 6) % 16;  // Corrected sum, taking only lower 4 bits
            Cout = 1'b1;
        end else begin
            // Sum does not exceed 9, no correction needed
            Sum = temp_sum[3:0];  // Take lower 4 bits of the sum
            Cout = 1'b0;
        end
    end
endmodule