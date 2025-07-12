module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_bin = A + B + Cin;
    
    // Check if the sum exceeds 9
    wire sum_exceeds_9 = (sum_bin > 9);
    
    // Apply BCD correction if the sum exceeds 9
    assign Sum = (sum_exceeds_9)? (sum_bin + 6) : sum_bin[3:0];
    
    // Generate carry-out if the sum exceeds 9
    assign Cout = (sum_exceeds_9)? 1'b1 : (sum_bin[4] == 1'b1)? 1'b1 : 1'b0;

endmodule