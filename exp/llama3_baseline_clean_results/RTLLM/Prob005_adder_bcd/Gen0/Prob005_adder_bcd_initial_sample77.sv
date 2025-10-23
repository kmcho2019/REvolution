module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    reg [4:0] sum_temp;
    reg [4:0] corrected_sum;

    always @(*) begin
        // Perform binary addition of A, B, and Cin
        sum_temp = A + B + Cin;
        
        // Check if the sum exceeds 9 (1001 in binary)
        if (sum_temp > 9) begin
            // Add 6 (0110 in binary) to the sum for correction
            corrected_sum = sum_temp + 6;
            // Generate carry-out (Cout)
            Cout = 1'b1;
        end else begin
            corrected_sum = sum_temp;
            Cout = 1'b0;
        end
        
        // Assign the corrected sum to the output Sum
        Sum = corrected_sum[3:0];
    end

endmodule