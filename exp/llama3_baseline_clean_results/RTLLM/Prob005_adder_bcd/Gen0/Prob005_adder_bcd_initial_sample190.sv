module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,    // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum
    output Cout   // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_temp = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    assign Sum = (sum_temp > 9) ? (sum_temp + 6) : sum_temp[3:0];
    
    // Determine if a carry-out is generated
    assign Cout = (sum_temp > 9) || (sum_temp + 6 > 9);

    // Alternative implementation for Cout using a more straightforward condition
    // assign Cout = (sum_temp[4] == 1);

endmodule