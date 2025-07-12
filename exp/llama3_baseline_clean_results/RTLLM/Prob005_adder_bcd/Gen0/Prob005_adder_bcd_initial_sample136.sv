module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;
    
    // Check if the sum exceeds 9 (binary 1001)
    wire exceed = binary_sum > 4'd9;
    
    // If the sum exceeds 9, add 6 to the sum and generate a carry-out
    assign Sum = exceed? (binary_sum + 4'd6)[3:0] : binary_sum[3:0];
    assign Cout = exceed? 1'b1 : binary_sum[4];

endmodule