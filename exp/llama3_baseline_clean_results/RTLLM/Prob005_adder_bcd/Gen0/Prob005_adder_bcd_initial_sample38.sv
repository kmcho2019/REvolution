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

    // Check if the sum exceeds 9 and perform BCD correction
    always @(*) begin
        if (temp_sum > 9) begin
            Sum = (temp_sum + 6) % 16; // Add 6 and take the lower 4 bits
            Cout = 1'b1; // Generate carry-out
        end else begin
            Sum = temp_sum[3:0]; // Take the lower 4 bits
            Cout = 1'b0; // No carry-out
        end
    end

endmodule