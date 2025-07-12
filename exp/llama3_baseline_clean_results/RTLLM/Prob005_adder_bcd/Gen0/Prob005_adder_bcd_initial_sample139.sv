module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [4:0] temp_sum;

    always @(A or B or Cin) begin
        // Perform binary addition
        temp_sum = A + B + Cin;
        
        // Check if sum exceeds 9 and apply BCD correction
        if (temp_sum > 9) begin
            // Add 6 to correct the sum
            temp_sum = temp_sum + 6;
            // Set carry-out to 1
            Cout = 1;
        end else begin
            // No correction needed, set carry-out to 0
            Cout = 0;
        end
        
        // Assign the corrected sum to output, ignoring the carry bit
        Sum = temp_sum[3:0];
    end

endmodule