module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly compute the binary sum of A, B, and Cin, maintaining the same logic but with a focus on minimizing operations
    wire [4:0] bin_sum = A + B + Cin;

    // Apply BCD correction if the sum exceeds 9, aiming to minimize additional logic
    assign Sum = (bin_sum > 9) ? (bin_sum + 6) : bin_sum;

    // Calculate Cout based on whether bin_sum exceeds 9 or has a carry bit, ensuring the logic is straightforward
    assign Cout = (bin_sum > 9) || bin_sum[4];

endmodule