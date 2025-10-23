module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Check if the sum exceeds 9 and generate the correct sum and carry-out
    always @(A, B, Cin) begin
        if (bin_sum > 9) begin
            Sum = bin_sum[3:0] + 4'd6;  // Add 6 to correct the sum
            Cout = 1'b1;  // Generate carry-out
        end else begin
            Sum = bin_sum[3:0];  // No correction needed
            Cout = bin_sum[4];  // Carry-out is the MSB of the binary sum
        end
    end

endmodule