module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] temp_sum;
    assign temp_sum = A + B + Cin;

    // Check if the sum exceeds 9 (binary 1001) and apply BCD correction if necessary
    always @(A, B, Cin) begin
        if (temp_sum > 9) begin
            // Apply BCD correction by adding 6 to the sum
            Sum = temp_sum + 6;
            // Generate carry-out signal since the sum exceeds 9
            Cout = 1;
        end else begin
            // No correction needed, just assign the sum
            Sum = temp_sum[3:0]; // Only take the lower 4 bits
            // No carry-out signal needed
            Cout = 0;
        end
    end

endmodule