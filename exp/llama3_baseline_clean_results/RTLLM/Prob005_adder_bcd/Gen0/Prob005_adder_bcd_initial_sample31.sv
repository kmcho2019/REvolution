module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    reg [4:0] temp_sum;

    always @(A, B, Cin) begin
        // Perform binary addition of A, B, and Cin
        temp_sum = A + B + Cin;
        
        // Check if the sum exceeds 9 and apply BCD correction
        if (temp_sum > 9) begin
            // Add 6 to the sum to bring it within the valid BCD range
            Sum = temp_sum + 6;
            // Set Cout to 1
            Cout = 1'b1;
        end else begin
            // No correction needed, just assign the sum
            Sum = temp_sum[3:0];
            // Set Cout to 0
            Cout = 1'b0;
        end
    end

endmodule