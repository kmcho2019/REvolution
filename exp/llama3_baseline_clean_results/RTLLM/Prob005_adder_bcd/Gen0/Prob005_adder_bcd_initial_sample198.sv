module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Internal signals for binary sum and carry
reg [4:0] binary_sum;

// Perform binary addition of A, B, and Cin
always @(A, B, Cin) begin
    binary_sum = A + B + Cin;
end

// Generate the BCD sum and carry-out based on the binary sum
always @(binary_sum) begin
    if (binary_sum > 9) begin
        Sum = binary_sum + 6;
        Cout = 1;
    end else begin
        Sum = binary_sum;
        Cout = 0;
    end
end

endmodule