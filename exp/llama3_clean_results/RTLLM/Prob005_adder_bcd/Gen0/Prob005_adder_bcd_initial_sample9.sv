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

    // BCD correction and carry generation
    always @(A, B, Cin) begin
        if (temp_sum > 9) begin
            // Apply BCD correction by adding 6
            Sum = temp_sum + 6;
            // Set carry-out flag
            Cout = 1'b1;
        end else begin
            // No correction needed, just assign the sum
            Sum = temp_sum[3:0];
            // Reset carry-out flag
            Cout = 1'b0;
        end
    end

endmodule