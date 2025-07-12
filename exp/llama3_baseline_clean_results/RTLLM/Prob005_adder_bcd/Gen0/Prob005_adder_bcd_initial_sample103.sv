module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Internal signal to hold the sum of A, B, and Cin
    wire [4:0] sum_internal;

    // Perform binary addition of A, B, and Cin
    assign sum_internal = A + B + Cin;

    // Generate Cout when the sum exceeds 9 (after initial addition)
    assign Cout = (sum_internal > 9)? 1'b1 : 1'b0;

    // Apply BCD correction if sum exceeds 9
    assign Sum = (sum_internal > 9)? (sum_internal + 6) : sum_internal;

    // Ensure Sum is 4 bits by masking off the MSB
    assign Sum = Sum[3:0];

endmodule