module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] sum_temp;
    always @(*) begin
        sum_temp = A + B + Cin;
        
        // Check if the sum exceeds 9
        if (sum_temp > 9) begin
            // Add 6 to the sum and generate a carry-out
            Sum = sum_temp[3:0] + 4'd6;
            Cout = 1'b1;
        end else begin
            // No correction needed, just assign the sum
            Sum = sum_temp[3:0];
            Cout = 1'b0;
        end
    end

endmodule